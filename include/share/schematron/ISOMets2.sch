<schema xmlns="http://purl.oclc.org/dsdl/schematron" >
	<phase id="phase.sum_check">
 		<active pattern="sum_equals_100_percent"/>
  	</phase>
 	<phase id="phase.entries_check">
     	<active pattern="all_positive"/>
  	</phase>
   	<pattern id="sum_equals_100_percent">
    	<title>Sum equals 100%.</title>
    	<rule context="Total">
      		<assert test="sum(//Percent)=100">Sum is not 100%.</assert>
     	</rule>
   	</pattern>
  	<pattern id="all_positive">
    	<title>All entries must be positive.</title>
    	<rule context="Percent">
       		<assert test="number(.)>0">Number (<value-of select="."/>) not positive</assert>
    	</rule>
   	</pattern>
 </schema>