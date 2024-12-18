#! /usr/bin/awk -f
# this script gets the Reaxys identification substance, its molecular formula, year and Reaxys document identification where the substances was published first time, 
# This script is based on the idea of Andres Camilo Marulanda Bran on July 14 2022.
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
		    rgx=".*<"pattern".*>(.+)</"pattern">"#If the field belongs to the list, its value is stored
		    data[pattern]=data[pattern] ":" gensub(rgx,"\\1","g",$0)
	    }
		if(pattern!=rxdets[1]){
		    rgx=".*<"pattern">(.+)</"pattern">"#If the field belongs to the list, its value is stored
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



