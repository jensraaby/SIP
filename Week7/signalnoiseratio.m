function snr = signalnoiseratio(origimg,newimg)
    new_sum_squared = sum(newimg(:).^2);
    error_sum_squared = sum((newimg(:)-origimg(:)).^2);
    snr = new_sum_squared/error_sum_squared;