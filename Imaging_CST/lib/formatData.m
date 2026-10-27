function formatedData = formatData(data,format)

mag_data = abs(data)/max(abs(data));
% mag_data = abs(data)/0.8589;

switch lower(format)
    case 'db'
        disp('Normilized MAG in dB')
        formatedData = 20*log10(mag_data);

    case 'linear'
        disp('Normilized MAG')
        formatedData = mag_data;
        
    case 'real'
        disp('Real part')
        formatedData = real(data);
        
    case 'imag'
        disp('Imag part')
        formatedData = imag(data);
        
        
    otherwise
        disp('Unknown format.')
end
end

