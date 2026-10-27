function write_s22p(Sparams, freq, Z0, filename)
    [N, M, F] = size(Sparams);
    assert(N == M, 'Sparams must be square.');
    assert(length(freq) == F, 'Mismatch freq and Sparams');

    fid = fopen(filename, 'w');
    if fid < 0
        error('Cannot open file');
    end

    fprintf(fid, '# Hz S RI R %.1f\n', Z0);  % HEADER

    for k = 1:F
        fprintf(fid, '%.6e', freq(k));  % Start line with frequency
        count = 0;

        for j = 1:N  % COLUMN first (port 2)
            for i = 1:N  % ROW inside (port 1)
                s = Sparams(i,j,k);
                fprintf(fid, ' %.6e %.6e', real(s), imag(s));
                count = count + 1;
                if mod(count, 4) == 0 && (count < N*N)
                    fprintf(fid, '\n');
                end
            end
        end
        fprintf(fid, '\n');  % new freq block
    end

    fclose(fid);
end
