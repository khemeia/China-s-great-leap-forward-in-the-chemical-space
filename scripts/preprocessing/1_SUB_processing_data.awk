#! /usr/bin/awk -f
# This script gets Reaxys substance identification, i.e. molecular formula, first publication year and Reaxys document identification 
# The script is based upon a similar code by Andres Camilo Marulanda Bran as of July 14 2022.
# #
BEGIN {
    a="IDE.XRN,IDE.MF,CIT.PY,CNR.CNR"
    split(a,rxdets,",")
    gsub(",","\t",a)
    print a
}

{regx="<.*\\..*>.*<\\/.*\\..*>"
    if (match($0,regex) && !match($0,"response")) { 
	pattern=gensub(/.*<\/(.*?)>.*/,"\\1","g",$0)#Detects fields
	if(match(a,pattern)){
    		if(pattern==rxdets[1]){
		    rgx=".*<"pattern".*>(.+)</"pattern">"#If the field belongs to the list, it value it is storaged
		    data[pattern]=data[pattern] ":" gensub(rgx,"\\1","g",$0)
	    }
		if(pattern!=rxdets[1]){
		    rgx=".*<"pattern">(.+)</"pattern">"#If the field belongs to the list, it value it is storaged
		    data[pattern]=data[pattern] ":" gensub(rgx,"\\1","g",$0)
	    }

	}
    }
    if(match($0,"</substance>")){ # It is necessary indicate the end of the data for each substance
    	line=""
	for(i in rxdets){
		field=rxdets[i]
		sub(":","",data[field]) # Remove first ":"
		line=line "\t" data[field]		
	    }
	sub("\t","",line)#Remove the first "\t"
      	print line
	delete data # The list have been cleaned
    }
}



