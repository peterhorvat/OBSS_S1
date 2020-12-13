function Detector  %(record )
  % Summary of this function and detailed explanation goes here

  % First convert the record into matlab (creates recordm.mat):
  % wfdb2mat -r record
  files = dir(fullfile('db','*.mat'));
  
  for k = 1:length(files)
      fileName = files(k).name;
      filePath = fullfile('db', fileName);
      shortName = erase(filePath,'m.mat');
      fprintf(1, 'Now processing %s\n', fileName);
      t=cputime();
      %m=5;
      %normalizeConst=32;
      idx = QRSDetect(filePath);
      fprintf('Running time: %f\n', cputime() - t);
      asciName = sprintf('%s.asc',shortName);
      fid = fopen(asciName, 'wt');
      for i=1:size(idx,2)
          fprintf(fid,'0:00:00.00 %d N 0 0 0\n', idx(1,i) );
      end
      fclose(fid);
  end
  
  
  % Now convert the .asc text output to binary WFDB format:
  % wrann -r record -a qrs <record.asc
  % And evaluate against reference annotations (atr) using bxb:
  % bxb -r record -a atr qrs
end

