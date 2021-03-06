#!usr/bin/perl
#estrapola dai report json i dati che servono per le statistiche
use JSON;
#use Data::Dumper;
#use strict;
$dir=$ARGV[0];


$list=qx(find '$dir' -maxdepth 1 -type d); #prendo le cartelle degli allegati

@dir_att=split(/\n/,$list);
#per ogni cartella allegato prendo i report
for ($i=1; $i<=$#dir_att; $i++){
	
	$list=qx(find '$dir_att[$i]/info' -maxdepth 1 -type f);
	#print $list;
	@json=split(/\n/,$list);
	for($j=0; $j<=$#json; $j++){
		@file=split(/\//,$json[$j]);  #file_name contiene i nomi dei file json dentro la cartella info

		@filename=split("[. ]",$file[$#file]); #dentro name ci sono le parti del nome del file json
		#$localtime=localtime();
		$localtime=time();
		
		#@date=split(" ", $localtime);
		#print "@filename : @date\n $filename[2] : $date[2]\n";
		use integer;
		$date=($localtime-$filename[0])/86400;
		print "$localtime - $filename[0] /86400 = $date\n";
		#if($filename[4] eq $date[4] && $filename[1] eq $date[1] && $filename[2] eq $date[2]){
		if($date==0){
			
			open(FILE,"<",$json[$j]) or die "no";
			$json_file=JSON->new->allow_nonref;
			$decjson=$json_file->decode(<FILE>);
			close FILE;

			
			@antivirus=keys %{$decjson->{"scans"}}; #tutti i nomi degli antivirus
			%map;
			foreach $a (@antivirus){ #per ogni antivirus aggiungo 1 se ha riconosciuto il file come virus
				if($decjson->{'scans'}{$a}->{'detected'} == 1){
					$map{$a}++;
				}else{
					$map{$a}+=0;
				}
			}
			
		}
	}
}


open(OUT, ">> stat.csv");
foreach $k(keys %map){
	$n_file= $#json+1;
	$perc=($map{$k}/$n_file)*100;
	print OUT time().",$k,$perc\n";
}
close OUT;
