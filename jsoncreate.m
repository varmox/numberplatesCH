i = "BE2789";
j = "LU537788";

format shortg
c = clock;
c = fix(c);
datetime = {c};
carnumber = j;

%jsonStr = jsonencode(table(time,carnumber));


str = jsonencode(table(datetime,carnumber));

str = strrep(str, ',"', sprintf(',\r"'));
str = strrep(str, '[{', sprintf('[\r{\r'));
str = strrep(str, '}]', sprintf('\r}\r]'));

fid1 = fopen('Daten.json', 'a');

if fid1 == -1, error('Cannot create JSON file');
end

fwrite(fid1, str, 'char');

fclose(fid1);

