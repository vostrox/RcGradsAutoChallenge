function sendPayload(ip, payload)
    adapter = udp(ip);
    
    fopen(adapter);
    
    fwrite(adapter, payload);
    
    fclose(adapter);
end

