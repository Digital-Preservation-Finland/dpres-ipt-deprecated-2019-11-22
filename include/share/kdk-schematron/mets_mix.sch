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
        <sch:rule context="mix:SpatialMetrics[mix:samplingFrequencyUnit=2 or mix:samplingFrequencyUnit=3]">
			<sch:assert test="mix:xSamplingFrequency">
				Element &lt;mix:xSamplingFrequency&gt; must be used if sampling frequency unit is inch or centimeter.
			</sch:assert>
			<sch:assert test="mix:ySamplingFrequency">
				Element &lt;mix:ySamplingFrequency&gt; must be used if sampling frequency unit is inch or centimeter.
			</sch:assert>			
		</sch:rule>
    </sch:pattern>

	<!--
	The pixels must contain atleast the numer of samples than expected in the color space.
	The pixels in palette color images can contain only one sample.
    Does not include validation for the following color spaces: TransparencyMask, ICCBased, Separation, Indexed, Pattern, DeviceN, Other
	-->
    <sch:pattern name="PixelSamplesInColorSpace">
	    <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='PaletteColor']">
			<sch:assert test="number(mix:samplesPerPixel)=1">
				Palette color image can contain only one sample per pixel, and &lt;mix:samplesPerPixel&gt; must be set as '1'.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='WhiteIsZero']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='BlackIsZero']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='RGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='CMYK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='YCbCr']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='CIELab']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='ICCLab']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceGray']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceCMYK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceCMYK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='Lab']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='sRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='e-sRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='sYCC']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='YCCK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- Colormap is obligatory in palette color images -->
    <sch:pattern name="ColorMap">
        <sch:rule context="mix:PhotometricInterpretation[mix:colorSpace='PaletteColor']">
			<sch:assert test="ancestor::mix:mix//mix:Colormap">
				The &lt;mix:Colormap&gt; element is obligatory for palette images.
			</sch:assert>
			<sch:assert test="ancestor::mix:mix//mix:colormapReference">
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
	
	<!-- If Color Profile is defined, then either ICC Profile or Local Profile must be defined, but not both -->
    <sch:pattern name="ColorProfile">
        <sch:rule context="mix:ColorProfile[ancestor::mix:mix//mix:colorSpace='ICCLab' or ancestor::mix:mix//mix:colorSpace='ICCBased']">
			<sch:assert test="mix:IccProfile">
				&lt;mix:IccProfile&gt; must be used, since the used color space is ICC-based.
			</sch:assert>
			<sch:assert test="not(mix:IccProfile and mix:LocalProfile)">
				Both &lt;mix:IccProfile&gt; or &lt;mix:LocalProfile&gt; defined. The other one should be removed.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ColorProfile">
			<sch:assert test="mix:IccProfile or mix:LocalProfile">
				Either &lt;mix:IccProfile&gt; or &lt;mix:LocalProfile&gt; element missing in &lt;mix:ColorProfile&gt; element.
			</sch:assert>
			<sch:assert test="not(mix:IccProfile and mix:LocalProfile)">
				Both &lt;mix:IccProfile&gt; or &lt;mix:LocalProfile&gt; defined. The other one should be removed.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- If ICC Profile is defined, then it need either a name or an URI. If Local Profile is defined, then it need atleast a name -->
    <sch:pattern name="ColorProfileDeeper">		
        <sch:rule context="mix:IccProfile">
			<sch:assert test="mix:iccProfileName or mix:iccProfileURI">
				Either &lt;mix:iccProfileName&gt; or &lt;mix:iccProfileURI&gt; element missing in &lt;mix:IccProfile&gt; element.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:LocalProfile">
			<sch:assert test="mix:localProfileName">
				Either &lt;mix:localProfileName&gt; element missing in &lt;mix:LocalProfile&gt; element.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	
	<!--
	If there are more samples in a pixel than expected in a color space, the extra samples must be defined.
	Does not include validation for the following color spaces: TransparencyMask, ICCBased, Separation, Indexed, Pattern, DeviceN, Other 
	-->
    <sch:pattern name="ExtraSamples">		
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='WhiteIsZero' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='BlackIsZero' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='RGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='CMYK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='YCbCr' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='CIELab' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='ICCLab' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceGray' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceCMYK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='DeviceCMYK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='Lab' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='sRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='e-sRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='sYCC' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[ancestor::mix:mix//mix:colorSpace='YCCK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
		
	</sch:pattern>

	
	
</sch:schema>
