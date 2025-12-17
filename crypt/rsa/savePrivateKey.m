function savePrivateKey(n, d)
    [f,p] = uiputfile('*.txt','Save Private Key','PrivateKeyRSA.txt');
    if isequal(f,0), return; end

    fid = fopen(fullfile(p,f),'w');
    fprintf(fid,'RSA_PRIVATE_KEY\n');
    fprintf(fid,'------------------------\n');
    fprintf(fid,'n=%d\n', n);
    fprintf(fid,'d=%d\n', d);
    fprintf(fid,'------------------------\n');
    fclose(fid);
end
