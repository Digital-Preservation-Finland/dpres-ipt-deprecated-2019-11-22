KDK Schema Change to EAD3

Extension elements in rows 1404-1405:
	<xs:any namespace="##other" processContents="lax"/>
	<xs:any namespace="##local" processContents="lax"/>
have been changed to:
	<xs:any namespace="##any" processContents="lax"/>

All validators are not able to handle the original code. The change extends the schema
so that it allows also elements from EAD3 itself. However, the Schematron validation
checks that no EAD3 elements have been used here.
