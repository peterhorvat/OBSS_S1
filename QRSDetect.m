function [found] = QRSDetect(fileName)
  S = load(fileName);
  M = 7;  % optimal is 5 or 7
  N = 30; % summation interval
  alpha = 0.6; % 0.01 <= alpha <= 0.1
  gamma = 0.16; % 0.15 <= gamma <= 0.2 -> weightening factor
  mat_signal = S.val(1,:); 
  win_size = 90;
  beat_win = 6;
  beat_span = 2;
   for n = 1:length(mat_signal)
      %HIGH PASS FILTER
     if (n >= M)   
      y1   = (1/M) * sum(mat_signal((n - (M - 1)) : n));
      y2   = mat_signal(n - ((M + 1)/2));
      hp_res(n) = y2 - y1;
    else
      hp_res(n) = 0;
    end
  end    
     %LOW PASS FILTER
     for p = 1:(length(hp_res)-N-1)
         hp_res(p) = sum(hp_res(p : p + N).^2);
     end
     hp_res = [zeros(1,(M+1)/2) hp_res(1:length(hp_res)-3)];
     %DECISION MAKING 
     temp = 0;
     threshold = max(hp_res(1:win_size));
     for i = 1:win_size:length(hp_res)-win_size
     [max_v,max_i] = max(hp_res(i:i+win_size));
        if max_v >= threshold
           if (max_i+i-beat_win > 0) && (max_i+i+beat_win<length(hp_res))
            if all(hp_res(max_i+i-beat_win:max_i+i+beat_win) >  threshold)
                if (temp <= 0)
                    temp = beat_span;
                    hp_res(max_i+i) = 1;
                    threshold = alpha * gamma * max_v + (1 - alpha) * threshold;
                end
            end
           elseif (max_i+i-beat_win < 0)
               if all(hp_res(1:max_i+i+beat_win) >  threshold)
                if (temp <= 0)
                    temp = beat_span;
                    hp_res(max_i+i) = 1;
                    threshold = alpha * gamma * max_v + (1 - alpha) * threshold;
                end
               end
           elseif (max_i+i+beat_win>length(hp_res))
               if all(hp_res(max_i+i-beat_win:length(hp_res)) >  threshold)
                if (temp <= 0)
                    temp = beat_span;
                    hp_res(max_i+i) = 1;
                    threshold = alpha * gamma * max_v + (1 - alpha) * threshold;
                end
               end
           end
        end
        temp = temp - 1;
     end
  found = find(hp_res==1);
end

  
  
  