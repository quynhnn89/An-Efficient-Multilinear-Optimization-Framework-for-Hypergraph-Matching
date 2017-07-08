function mynfunc(a, b, c)
if ~exist('a', 'var') || isempty(a)
    disp('a not exists or empty');
end

if ~exist('b', 'var')
    disp('b not exists');
end

if ~exist('c', 'var')
    disp('c not exists ');
end

