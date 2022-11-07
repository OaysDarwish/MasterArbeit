plot(data.speed_kmh)

speed_ms = 0;
accel_ms = zeros(1,1000);
accel_ms = cat(2,accel_ms, ones(1,1*3000) * 1);
accel_ms = cat(2,accel_ms, ones(1,1*3000) * (-1));
accel_ms = cat(2,accel_ms, zeros(1,1000));
accel_ms = cat(2,accel_ms, ones(1,1*3000) * (-10));
accel_ms = cat(2,accel_ms, ones(1,1*3000) * (10));
accel_ms = cat(2,accel_ms, zeros(1,1000));
accel_ms = cat(2,accel_ms, ones(1,1*10000) * 1);
accel_ms = cat(2,accel_ms, ones(1,1*20000) * (-1));
accel_ms = cat(2,accel_ms, ones(1,1*10000) * 1);
accel_ms = cat(2,accel_ms, zeros(1,1000));

accel_ms = cat(2,accel_ms, zeros(1,1000));

accel_ms = cat(2,accel_ms, zeros(1,100000));
speed_kmh_1Hz = 0;
      for i=1:length(data.speed_kmh)
          % do something on x(i)
          t = i/100;
          
          
          speed_ms = speed_ms + accel_ms(i)/100; 
          
          if mod(i,100) == 0
            speed_kmh_1Hz = speed_ms * 3.6;
          end
          
          data.speed_kmh(i) = speed_kmh_1Hz;
      end
      
      plot(data.speed_kmh)