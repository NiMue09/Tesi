#!usr/bin/perl
#cerca i file da scansionare nella cartella specificata e avvia su ognuno lo script dell'API
$start_dir=$ARGV[0];
$list=qx(find '$start_dir' -maxdepth 2 -type f);

@files=split(/\n/,$list);

foreach $file (@files){
	print "$file\n";
	print STDOUT qx(perl /home/nimue/Scrivania/Tesi/test/api5.pl "$file");
	sleep(15);
}
