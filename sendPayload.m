function sendPayload(payload)
    adapter = udp('255.255.255.255', 9090);
    
    fopen(adapter);
    
    fwrite(adapter, payload);
    
    fclose(adapter);
end

