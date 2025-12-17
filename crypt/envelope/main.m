function main()
%% ---------- PATHS (optional; edit or comment if already on path) ----------
% addpath('C:\...\AES_Simple_DavidHill');   % DH_Cipher / DH_InvCipher (if used by KMS)
% addpath('C:\...\GCM_BlockCipher');        % GCM_AE / GCM_AD (uses Cipher_gcm internally)
% addpath('C:\...\kms');                    % KMS.m

clc;

%% ---------- INPUTS ----------
plainTextInput= 'Something else here';
iv  = '4392367e62ef9aa706e3e867';  % 12-byte GCM nonce (hex)
aad = 'additional unencrypted instructions';


%% ---------- KMS: init, rotate, policy ----------
if isfile('kms_store.mat')
    load('kms_store.mat','kms');
    fprintf('[KMS] Loaded existing KMS store\n');
else
    kms = KMS.init();
    fprintf('[KMS] New KMS store created\n');
end
 %% KMS KEY VERSIONING (KEKs)
[kms] = KMS.rotate(kms);        % create KEK v1

save('kms_store.mat','kms');   % persist KMS
%% ---------- Generate DEK, encrypt with AES-GCM (inner layer) ----------
DEK = uint8(randi([0,255],[1,32]));            % 32B (AES-256)
key_hex = bytes_to_hex(DEK);                   % your GCM expects hex key
[C, T] = GCM_AE(key_hex, iv, plainTextInput, aad);      % C, T are hex strings

%% ---------- Wrap DEK with KMS (outer layer) ----------
[wrappedDEK, kms] = KMS.wrap(kms, DEK);
save('kms_store.mat','kms');  % store updated versions


%% ---------- Print ENVELOPE (store this with the object) ----------
fprintf('\n--- ENVELOPE ---\n');
fprintf('IV (hex):         %s\n', lower(iv));
fprintf('Tag (hex):        %s\n', lower(T));
fprintf('Ciphertext bytes: %d\n', numel(C)/2);
fprintf('wrappedDEK bytes: %d\n', numel(wrappedDEK));
fprintf('CT preview:       %s ...\n', hex_preview(C, 32));

% Persistable envelope struct
envelope.iv          = iv;
envelope.tag         = T;
envelope.ciphertext  = C;
envelope.wrappedDEK  = wrappedDEK;
envelope.aad         = aad;
save('envelope.mat','envelope');
fprintf('[SAVE] Envelope stored in envelope.mat\n');
%% ----------DECRYPT ----------

fprintf('\n== DECRYPTION TEST ==\n');

% Load KMS + envelope (simulate separate decryption program)
load('kms_store.mat','kms');
load('envelope.mat','envelope');
% unwrap DEK using correct version
[DEK_u, kms] = KMS.unwrap(kms, envelope.wrappedDEK);
key_hex_u = bytes_to_hex(DEK_u);
% decrypt data using AES-GCM
[P, A] = GCM_AD(key_hex_u, envelope.iv, envelope.ciphertext, envelope.aad, envelope.tag);

ok = isequal(P, plainTextInput);
fprintf('Auth OK: %d | Plaintext match: %d\n', A, ok);
fprintf('Recovered preview: %s\n', safe_text_preview(P,120));

fprintf('\n== DONE ==\n');
end


%% ----------------- helpers -----------------
function s = safe_text_preview(u8, n)
% Show first n bytes as readable text (non-printables → '.')
  n = min(n, numel(u8));
  b = char(u8(1:n));
  mask = (b < 32) | (b > 126);
  b(mask) = '.';
  s = string(b);
end

function hex = bytes_to_hex(u8)
  hex = reshape(dec2hex(u8).',1,[]);
end

function s = hex_preview(hexStr, nBytes)
  nChars = min(2*nBytes, numel(hexStr));
  s = lower(hexStr(1:nChars));
end

function out = capitalize(s)
  if isempty(s), out = s; return; end
  s(1) = upper(s(1)); out = s;
end
