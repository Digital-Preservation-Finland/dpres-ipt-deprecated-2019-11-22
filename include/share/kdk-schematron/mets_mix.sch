<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>Joku otsikko</sch:title>
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>

    <sch:pattern name="##">
        <sch:rule context="mix:Compression[mix:compressionScheme='enumerated in local list']">
			<sch:assert test="mix:compressionSchemeLocalList">
				Ei natsaa
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:Compression[mix:compressionScheme='enumerated in local list']">
			<sch:assert test="mix:compressionSchemeLocalValue">
				Ei natsaa
			</sch:assert>			
		</sch:rule>
    </sch:pattern>

    <sch:pattern name="##">
        <sch:rule context="mix:PhotometricInterpretation[mix:colorSpace='YCbCr']">
			<sch:assert test="mix:YCbCr">
				Ei natsaa
			</sch:assert>
			<sch:assert test="mix:yCbCrSubSampling">
				Ei natsaa
			</sch:assert>
			<sch:assert test="mix:yCbCrPositioning">
				Ei natsaa
			</sch:assert>
			<sch:assert test="mix:yCbCrCoefficients">
				Ei natsaa
			</sch:assert>
		</sch:rule>
    </sch:pattern>

    <sch:pattern name="##">
        <sch:rule context="mix:PhotometricInterpretation[mix:colorSpace='YCbCr']">
			<sch:assert test="mix:referenceBlackWhite">
				Ei natsaa
			</sch:assert>
		</sch:rule>
    </sch:pattern>

    <sch:pattern name="##">
        <sch:rule context="mix:SpatialMetrics[mix:samplingFrequencyUnit=2|mix:samplingFrequencyUnit=3]">
			<sch:assert test="mix:xSamplingFrequency">
				Ei natsaa
			</sch:assert>
			<sch:assert test="mix:ySamplingFrequency">
				Ei natsaa
			</sch:assert>			
		</sch:rule>
    </sch:pattern>
    <sch:pattern name="##">
        <sch:rule context="mix:SpatialMetrics[mix:samplingFrequencyUnit=1]">
			<sch:assert test="count(mix:xSamplingFrequency)=0">
				Ei natsaa
			</sch:assert>
			<sch:assert test="count(mix:ySamplingFrequency)=0">
				Ei natsaa
			</sch:assert>			
		</sch:rule>
    </sch:pattern>
    <sch:pattern name="##">
        <sch:rule context="mix:mix//mix:PhotometricInterpretation[mix:colorSpace='PaletteColor']">
			<sch:assert test="ancester::mix:mix//mix:samplesPerPixel=1">
				Ei natsaa
			</sch:assert>
		</sch:rule>
    </sch:pattern>
    <sch:pattern name="##">
        <sch:rule context="mix:mix//mix:PhotometricInterpretation[mix:colorSpace='PaletteColor']">
			<sch:assert test="ancester::mix:mix//mix:Colormap">
				Ei natsaa
			</sch:assert>
			<sch:assert test="ancester::mix:mix//mix:colormapReference">
				Ei natsaa
			</sch:assert>
		</sch:rule>
    </sch:pattern>
    <sch:pattern name="##">
        <sch:rule context="mix:grayResponse[mix:grayResponseCurve]">
			<sch:assert test="mix:grayResponseUnit">
				Ei natsaa
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
    <sch:pattern name="##">
        <sch:rule context="premis:grayResponse[mix:grayResponseCurve]">
			<sch:assert test="mix:grayResponseUnit">
				Ei natsaa
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
</sch:schema>
