function p21()

%% a
SAMPLE_SIZE0 = 6;
SAMPLE_SIZE1 = 8;
MU0 = 1;
MU1 = 1.5;
MUError = 0;
STD_DEV = 0.25;

% set seed for random generator
rng(1);

% compute the new Y
Y0 = MU0 + MUError + STD_DEV .* randn(SAMPLE_SIZE0, 1);
Y1 = MU1 + MUError + STD_DEV .* randn(SAMPLE_SIZE1, 1);

%% a

% apply t-test, H should be 1
[H,P,CI,STATS] = ttest2(Y1, Y0);

Tval = STATS.tstat
%% b

D = [Y0; Y1];

indices = 1:SAMPLE_SIZE0+SAMPLE_SIZE1;

I1 = combnk(indices, 6);
NR_PERMS = size(I1,1);
I2 = zeros(NR_PERMS,8);
tstats = zeros(NR_PERMS, 1);
meanDiffs = zeros(NR_PERMS, 1);

D1 = D(I1);


for i=1:NR_PERMS
  I2(i,:) = setdiff(indices, I1(i,:));
  D2 = D(I2(i,:));
  [~, ~, ~, STATS]= ttest2(D1(i,:), D2);
  tstats(i) = STATS.tstat;
  
  % c
  meanDiffs(i) = mean(D1(i,:)) -  mean(D2);
end

pVal = nnz(tstats > Tval)/NR_PERMS;

%% c

meansDiffOrig = mean(Y1) - mean(Y0);

pValMeans = nnz(meanDiffs > meansDiffOrig)/NR_PERMS;

%% d

% i
tstatsD = zeros(NR_PERMS, 1);
NR_PERMS_RAND = 1000;
perms = zeros(NR_PERMS_RAND,SAMPLE_SIZE0 + SAMPLE_SIZE1);

for i=1:NR_PERMS_RAND
  perms(i,:) = randperm(SAMPLE_SIZE0 + SAMPLE_SIZE1);
  D1 = D(perms(i,1:SAMPLE_SIZE0));
  D2 = D(perms(i,SAMPLE_SIZE0+1:end));
  [~, ~, ~, STATS]= ttest2(D1, D2);
  tstatsD(i) = STATS.tstat;
end

pValD = nnz(tstatsD > Tval)/NR_PERMS_RAND; % p-value is zero for 1,000 runs, 3e-04 for 10,000 runs

% iii

dup_nr = 0;
for i=1:NR_PERMS_RAND
  i
  for j=i+1:NR_PERMS_RAND
    if (sum (abs(perms(i,:) - perms(j,:))) == 0)
      dup_nr = dup_nr + 1;
      fprintf('i:%d j:%d', i, j);
      break;
    end
  end
end

dup_tstatsD = 0;
sortedTstatsD = sort(tstatsD);

for i=1:NR_PERMS_RAND-1
  if (sortedTstatsD(i) == sortedTstatsD(i+1))
    dup_tstatsD = dup_tstatsD+1;
    i
  end
end




end