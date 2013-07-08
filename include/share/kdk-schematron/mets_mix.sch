<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>NISOIMG (MIX) metadata issues</sch:title>

<!--
Validates various issues in NISOIMG (MIX) metadata.
Juha Lehtonen 2013-07-08 : Initial version
-->
	
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>

	<!-- Compression scheme is in separate list -->
    <sch:pattern name="EnumeratedCompressionList">
        <sch:rule context="mix:Compression[mix:compressionScheme='enumerated in local list']">
			<sch:assert test="mix:compressionSchemeLocalList">
				Element &lt;mix:compressionSchemeLocalList&gt; must be used if the value of &lt;mix:compressionScheme&gt; is 'enumerated in local list'.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:Compression[mix:compressionScheme='enumerated in local list']">
			<sch:assert test="mix:compressionSchemeLocalValue">
				Element &lt;mix:compressionSchemeLocalValue&gt; must be used if the value of &lt;mix:compressionScheme&gt; is 'enumerated in local list'.
			</sch:assert>			
		</sch:rule>
    </sch:pattern>

	<!-- YCbCr colorspace requires specific elements -->
    <sch:pattern name="YCbCr">
        <sch:rule context="mix:PhotometricInterpretation[mix:colorSpace='YCbCr']">
			<sch:assert test="mix:YCbCr">
				Element &lt;mix:YCbCr&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
			<sch:assert test="mix:yCbCrSubSampling">
				Element &lt;mix:YCbCrSubSampling&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
			<sch:assert test="mix:yCbCrPositioning">
				Element &lt;mix:YCbCrPositioning&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
			<sch:assert test="mix:yCbCrCoefficients">
				Element &lt;mix:YCbCrCoefficients&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:PhotometricInterpretation[mix:colorSpace='YCbCr']">
			<sch:assert test="mix:referenceBlackWhite">
				Element &lt;mix:referenceBlackWhite&gt; must be used, if the color space is YCbCr.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- The values of sampling frequency must be used, if the unit is given -->
    <sch:pattern name="SamplingFrequency">
        <sch:rule context="mix:SpatialMetrics[mix:samplingFrequencyUnit=2|mix:samplingFrequencyUnit=3]">
			<sch:assert test="mix:xSamplingFrequency">
				Element &lt;mix:xSamplingFrequency&gt; must be used if sampling frequency unit is inch or centimeter.
			</sch:assert>
			<sch:assert test="mix:ySamplingFrequency">
				Element &lt;mix:ySamplingFrequency&gt; must be used if sampling frequency unit is inch or centimeter.
			</sch:assert>			
		</sch:rule>
    </sch:pattern>

	<!-- The pixels in palette color images can contain only one sample -->
    <sch:pattern name="PixelSamplesInPaletteColor">
        <sch:rule context="mix:mix//mix:PhotometricInterpretation[mix:colorSpace='PaletteColor']">
			<sch:assert test="ancester::mix:mix//mix:samplesPerPixel=1">
				Palette color image can contain only one sample per pixel, and &lt;mix:samplesPerPixel&gt; must be set as '1'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Colormap is obligatory in palette color images -->
    <sch:pattern name="ColorMap">
        <sch:rule context="mix:mix//mix:PhotometricInterpretation[mix:colorSpace='PaletteColor']">
			<sch:assert test="ancester::mix:mix//mix:Colormap">
				The &lt;mix:Colormap&gt; element is obligatory for palette images.
			</sch:assert>
			<sch:assert test="ancester::mix:mix//mix:colormapReference">
				The &lt;mix:colormapReference&gt; element is obligatory for palette images.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- The gray response curves must have a unit -->
    <sch:pattern name="GrayResponseUnit">
        <sch:rule context="mix:grayResponse[mix:grayResponseCurve]">
			<sch:assert test="mix:grayResponseUnit">
				Element &lt;mix:grayResponseUnit&gt; is obligatory, if element &lt;mix:grayResponseCurve&gt; is used.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
</sch:schema>
