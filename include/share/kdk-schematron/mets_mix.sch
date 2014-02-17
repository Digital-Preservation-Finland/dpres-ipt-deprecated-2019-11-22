<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>NISOIMG (MIX) metadata issues</sch:title>

<!--
Validates various issues in NISOIMG (MIX) metadata.
Juha Lehtonen 2013-07-08 : Initial version
Juha Lehtonen 2014-02-14 : False messages related to PreviousImageMetadata element fixed. Checks for JPEG2000 and bitsPerSampleValue elements added.
-->
	
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

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
			<sch:assert test="mix:YCbCr/mix:yCbCrSubSampling">
				Element &lt;mix:YCbCrSubSampling&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
			<sch:assert test="mix:YCbCr/mix:yCbCrPositioning">
				Element &lt;mix:YCbCrPositioning&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
			<sch:assert test="mix:YCbCr/mix:yCbCrCoefficients">
				Element &lt;mix:YCbCrCoefficients&gt; must be used, if the colorspace is YCbCr.
			</sch:assert>
			<sch:assert test="mix:YCbCr/mix:referenceBlackWhite">
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

	<!-- The number of values in bitsPerSampleValue must be same as the value in samplesPerPixel -->
    <sch:pattern name="BitsPerSample">
        <sch:rule context="mix:bitsPerSampleValue">
			<sch:let name="countValues" value="count(str:tokenize(.,','))"/>
			<sch:assert test="$countValues = number(../../mix:samplesPerPixel) or $countValues=1">
				Element &lt;mix:bitsPerSampleValue&gt; must have same count of values (separated with comma character) as the value in &lt;mix:samplesPerPixel&gt;.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	
	<!--
	The pixels must contain atleast the number of samples than expected in the color space.
	The pixels in palette color images can contain only one sample.
    Does not include validation for the following color spaces: TransparencyMask, ICCBased, Separation, Indexed, Pattern, DeviceN, Other
	-->
    <sch:pattern name="PixelSamplesInColorSpace">
	    <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='PaletteColor']">
			<sch:assert test="number(mix:samplesPerPixel)=1">
				Palette color image can contain only one sample per pixel, and &lt;mix:samplesPerPixel&gt; must be set as '1'.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='WhiteIsZero']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='BlackIsZero']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='RGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CMYK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='YCbCr']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CIELab']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='ICCLab']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceGray']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceCMYK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CalGray']">
			<sch:assert test="number(mix:samplesPerPixel)>=1">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CalRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='Lab']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='sRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='e-sRGB']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='sYCC']">
			<sch:assert test="number(mix:samplesPerPixel)>=3">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='YCCK']">
			<sch:assert test="number(mix:samplesPerPixel)>=4">
				The number of samples per pixel in element &lt;mix:samplesPerPixel&gt; is smaller than expected in the color space.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- Colormap is obligatory in palette color images -->
    <sch:pattern name="ColorMap">
        <sch:rule context="mix:PhotometricInterpretation[mix:colorSpace='PaletteColor']">
			<sch:assert test="../../../mix:ImageAssessmentMetadata/mix:ImageColorEncoding/mix:Colormap">
				The &lt;mix:Colormap&gt; element is obligatory for palette images.
			</sch:assert>
			<sch:assert test="../../../mix:ImageAssessmentMetadata/mix:ImageColorEncoding/mix:Colormap/mix:colormapReference">
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
        <sch:rule context="mix:ColorProfile[../mix:colorSpace='ICCLab' or ../mix:colorSpace='ICCBased']">
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
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='WhiteIsZero' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='BlackIsZero' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='RGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CMYK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='YCbCr' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CIELab' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='ICCLab' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceGray' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceCMYK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CalGray' and number(mix:samplesPerPixel)>1]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceCMYK' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='Lab' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='sRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='e-sRGB' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='sYCC' and number(mix:samplesPerPixel)>3]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:ImageColorEncoding[../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='YCCK' and number(mix:samplesPerPixel)>4]">
			<sch:assert test="mix:extraSamples">
				Element &lt;mix:extraSamples&gt; must be used since &lt;mix:samplesPerPixel&gt; element has a greater value than expected in the color space.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- JPEG2000 specific check -->
	<sch:pattern name="JPEG2000">
        <sch:rule context="mix:BasicImageInformation[../mix:BasicDigitalObjectInformation/mix:FormatDesignation/mix:formatName='image/jp2']">
			<sch:assert test="mix:SpecialFormatCharacteristics">
				Element &lt;mix:SpecialFormatCharacteristics&gt; must be used for JPEG2000 images.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:SpecialFormatCharacteristics[../../mix:BasicDigitalObjectInformation/mix:FormatDesignation/mix:formatName='image/jp2']">
			<sch:assert test="mix:JPEG2000">
				Element &lt;mix:JPEG2000&gt; must be used for JPEG2000 images.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:SpecialFormatCharacteristics[../../mix:BasicDigitalObjectInformation/mix:FormatDesignation/mix:formatName
		and not(../../mix:BasicDigitalObjectInformation/mix:FormatDesignation/mix:formatName='image/jp2')]">
			<sch:assert test="not(mix:JPEG2000)">
				Element &lt;mix:JPEG2000&gt; is not applicable for other types than JPEG2000 images.
			</sch:assert>
		</sch:rule>		
        <sch:rule context="mix:JPEG2000">
			<sch:assert test="mix:EncodingOptions">
				Element &lt;mix:EncodingOptions&gt; must be used for JPEG2000 images.
			</sch:assert>
		</sch:rule>
        <sch:rule context="mix:EncodingOptions">
			<sch:assert test="mix:qualityLayers">
				Element &lt;mix:qualityLayers&gt; must be used for JPEG2000 images.
			</sch:assert>
			<sch:assert test="mix:resolutionLevels">
				Element &lt;mix:resolutionLevels&gt; must be used for JPEG2000 images.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
</sch:schema>
