function env = kms_gui_flow(action, env)

switch action

    case 'init_kms'
        if isfile('kms_store.mat')
            load('kms_store.mat','kms');
        else
            kms = KMS.init();
        end
        kms = KMS.rotate(kms);
        save('kms_store.mat','kms');
        env.kms = kms;

    case 'encrypt_inner'
        DEK = uint8(randi([0,255],[1,32]));
        env.DEK = DEK;

        key_hex = reshape(dec2hex(DEK).',1,[]);
        [C,T] = GCM_AE(key_hex, env.iv, env.plainTextInput, env.aad);

        env.ciphertext = C;
        env.tag = T;

    case 'wrap_dek'
        [wrapped,kms] = KMS.wrap(env.kms, env.DEK);
        save('kms_store.mat','kms');
        env.kms = kms;
        env.wrappedDEK = wrapped;

        env.envelope = struct( ...
            'iv', env.iv, ...
            'tag', env.tag, ...
            'ciphertext', env.ciphertext, ...
            'wrappedDEK', wrapped, ...
            'aad', env.aad ...
        );

    case 'unwrap_dek'
        load('kms_store.mat','kms');
        [DEK,kms] = KMS.unwrap(kms, env.envelope.wrappedDEK);
        save('kms_store.mat','kms');
        env.kms = kms;
        env.DEK = DEK;

    case 'decrypt'
        key_hex = reshape(dec2hex(env.DEK).',1,[]);
        [P,A] = GCM_AD( ...
            key_hex, ...
            env.envelope.iv, ...
            env.envelope.ciphertext, ...
            env.envelope.aad, ...
            env.envelope.tag ...
        );
        env.decryptedText = P;
        env.authOK = A;
end
end
