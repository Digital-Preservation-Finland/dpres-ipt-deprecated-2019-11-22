<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.5.0">
	<sch:title>NISOIMG (MIX) metadata validation</sch:title>

<!--
Validates NISOIMG (MIX) metadata.
-->
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<sch:include href="./abstracts/disallowed_element_format_specific_pattern.incl"/>
	<sch:include href="./abstracts/required_element_format_specific_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_element_other_pattern.incl"/>
	<sch:include href="./abstracts/required_element_xor_element_pattern.incl"/>
	<sch:include href="./abstracts/required_element_or_element_pattern.incl"/>
	<sch:include href="./abstracts/mix_required_count_element_pattern.incl"/>
	<sch:include href="./abstracts/mix_required_number_color_samples_pattern.incl"/>

	<!-- Mandatory elements -->
	<sch:pattern id="mix_BasicDigitalObjectInformation" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:BasicDigitalObjectInformation"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_BasicImageInformation" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:BasicImageInformation"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_ChangeHistory" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:ChangeHistory"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<sch:pattern id="mix_objectIdentifierType" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ObjectIdentifier"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:objectIdentifierType"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_objectIdentifierValue" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ObjectIdentifier"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:objectIdentifierValue"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_formatName" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:FormatDesignation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:formatName"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_Compression" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BasicDigitalObjectInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:Compression"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_compressionScheme" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:Compression"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:compressionScheme"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_messageDigestAlgorithm" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:Fixity"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:messageDigestAlgorithm"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_messageDigest" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:Fixity"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:messageDigest"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_BasicImageCharacteristics" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BasicImageInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:BasicImageCharacteristics"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_imageWidth" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BasicImageCharacteristics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:imageWidth"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_imageHeight" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BasicImageCharacteristics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:imageHeight"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_PhotometricInterpretation" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BasicImageCharacteristics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:PhotometricInterpretation"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_colorSpace" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:PhotometricInterpretation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:colorSpace"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_ImageColorEncoding" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ImageAssessmentMetadata"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:ImageColorEncoding"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_BitsPerSample" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ImageColorEncoding"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:BitsPerSample"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_samplesPerPixel" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ImageColorEncoding"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:samplesPerPixel"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_bitsPerSampleValue" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BitsPerSample"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:bitsPerSampleValue"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_bitsPerSampleUnit" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:BitsPerSample"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:bitsPerSampleUnit"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_YCbCrSubSampling" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:YCbCr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:YCbCrSubSampling"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_yCbCrPositioning" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:YCbCr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:yCbCrPositioning"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_yCbCrCoefficients" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:YCbCr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:yCbCrCoefficients"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_referenceBlackWhite" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:YCbCr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:referenceBlackWhite"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Compression scheme is in separate list -->
	<sch:pattern id="mix_compressionSchemeLocalList" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:Compression"/>
		<sch:param name="context_condition" value="mix:compressionScheme='enumerated in local list'"/>
		<sch:param name="required_element" value="mix:compressionSchemeLocalList"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_compressionSchemeLocalValue" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:Compression"/>
		<sch:param name="context_condition" value="mix:compressionScheme='enumerated in local list'"/>
		<sch:param name="required_element" value="mix:compressionSchemeLocalValue"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- YCbCr -->
	<sch:pattern id="mix_YCbCr" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:PhotometricInterpretation"/>
		<sch:param name="context_condition" value="mix:colorSpace='YCbCr'"/>
		<sch:param name="required_element" value="mix:YCbCr"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Sampling frequency -->
	<sch:pattern id="mix_xSamplingFrequency" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:SpatialMetrics"/>
		<sch:param name="context_condition" value="mix:samplingFrequencyUnit=2 or mix:samplingFrequencyUnit=3"/>
		<sch:param name="required_element" value="mix:xSamplingFrequency"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_ySamplingFrequency" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:SpatialMetrics"/>
		<sch:param name="context_condition" value="mix:samplingFrequencyUnit=2 or mix:samplingFrequencyUnit=3"/>
		<sch:param name="required_element" value="mix:ySamplingFrequency"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- The number of values in bitsPerSampleValue must be same as the value in samplesPerPixel -->
	<sch:pattern id="mix_count_samples" is-a="mix_required_count_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:bitsPerSampleValue"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="count_element" value="../../mix:samplesPerPixel"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!--
	The pixels must contain atleast the number of samples than expected in the color space.
	The pixels in palette color images can contain only one sample.
	Does not include validation for the following color spaces: TransparencyMask, ICCBased, Separation, Indexed, Pattern, DeviceN, Other
	-->
	<sch:pattern id="mix_count_color_samples_PaletteColor" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('PaletteColor')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="="/>
		<sch:param name="num" value="string('1')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_WhiteIsZero" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('WhiteIsZero')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('1')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_BlackIsZero" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('BlackIsZero')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('1')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_RGB" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('RGB')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_CMYK" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('CMYK')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('4')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_YCbCr" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('YCbCr')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_CIELab" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('CIELab')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_ICCLab" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('ICCLab')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_DeviceGray" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('DeviceGray')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('1')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_DeviceRGB" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('DeviceRGB')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_DeviceCMYK" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('DeviceCMYK')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('4')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_CalGray" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('CalGray')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('1')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_CalRGB" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('CalRGB')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_Lab" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('Lab')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_sRGB" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('sRGB')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_esRGB" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('e-sRGB')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_sYCC" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('sYCC')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('3')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_count_color_samples_YCCK" is-a="mix_required_number_color_samples_pattern">
		<sch:param name="color_space" value="string('YCCK')"/>
		<sch:param name="samples_pixel" value="mix:samplesPerPixel"/>
		<sch:param name="oper" value="&gt;="/>
		<sch:param name="num" value="string('4')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- Colormap is obligatory in palette color images -->
	<sch:pattern id="mets_Colormap" is-a="required_element_other_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:PhotometricInterpretation"/>
		<sch:param name="context_condition" value="mix:colorSpace='PaletteColor'"/>
		<sch:param name="required_element" value="../../../mix:ImageAssessmentMetadata/mix:ImageColorEncoding/mix:Colormap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_colormapReference" is-a="required_element_other_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:PhotometricInterpretation"/>
		<sch:param name="context_condition" value="mix:colorSpace='PaletteColor'"/>
		<sch:param name="required_element" value="../../../mix:ImageAssessmentMetadata/mix:ImageColorEncoding/mix:Colormap/mix:colormapReference"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- The gray response curves must have a unit -->
	<sch:pattern id="mix_grayResponseUnit" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:grayResponse"/>
		<sch:param name="context_condition" value="mix:grayResponseCurve"/>
		<sch:param name="required_element" value="mix:grayResponseUnit"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_IccProfile" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ColorProfile"/>
		<sch:param name="context_condition" value="../mix:colorSpace='ICCLab' or ../mix:colorSpace='ICCBased'"/>
		<sch:param name="required_element" value="mix:IccProfile"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- If Color Profile is defined, then either ICC Profile or Local Profile must be defined, but not both -->
	<sch:pattern id="mets_IccProfile_xor_LocalProfile" is-a="required_element_xor_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ColorProfile"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element1" value="mix:IccProfile"/>
		<sch:param name="required_element2" value="mix:LocalProfile"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- If ICC Profile is defined, then it need either a name or an URI. If Local Profile is defined, then it need atleast a name -->
	<sch:pattern id="mix_localProfileName" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:LocalProfile"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:localProfileName"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_iccProfileName_or_iccProfileURI" is-a="required_element_or_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:IccProfile"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element1" value="mix:iccProfileName"/>
		<sch:param name="required_element2" value="mix:iccProfileURI"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!--
	If there are more samples in a pixel than expected in a color space, the extra samples must be defined.
	Does not include validation for the following color spaces: TransparencyMask, ICCBased, Separation, Indexed, Pattern, DeviceN, Other 
	-->
	<sch:pattern id="mix_extraSamples" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:ImageColorEncoding"/>
		<sch:param name="context_condition" value="(../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='WhiteIsZero' and number(mix:samplesPerPixel)>1)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='BlackIsZero' and number(mix:samplesPerPixel)>1)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='RGB' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CMYK' and number(mix:samplesPerPixel)>4)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='YCbCr' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CIELab' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='ICCLab' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceGray' and number(mix:samplesPerPixel)>1)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceRGB' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='DeviceCMYK' and number(mix:samplesPerPixel)>4)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='CalGray' and number(mix:samplesPerPixel)>1)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='Lab' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='sRGB' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='e-sRGB' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='sYCC' and number(mix:samplesPerPixel)>3)
		or (../../mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:PhotometricInterpretation/mix:colorSpace='YCCK' and number(mix:samplesPerPixel)>4)"/>
		<sch:param name="required_element" value="mix:extraSamples"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- JPEG2000 specific check -->
	<sch:pattern id="mix_SpecialFormatCharacteristics" is-a="required_element_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('image/jp2')"/>
		<sch:param name="required_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix/mix:BasicImageInformation/mix:SpecialFormatCharacteristics"/>
		<sch:param name="mdtype_name" value="string('NISOIMG (MIX)')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_JPEG2000" is-a="required_element_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('image/jp2')"/>
		<sch:param name="required_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix/mix:BasicImageInformation/mix:SpecialFormatCharacteristics/mix:JPEG2000"/>
		<sch:param name="mdtype_name" value="string('NISOIMG (MIX)')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_EncodingOptions" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:JPEG2000"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:EncodingOptions"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_qualityLayers" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:EncodingOptions"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:qualityLayers"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mix_resolutionLevels" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix//mix:qualityLayers"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mix:resolutionLevels"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>	
	
	<!-- Not JPEG2000 file - specific check -->
	<sch:pattern id="mix_no_JPEG2000" is-a="disallowed_element_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('image/jp2')"/>
		<sch:param name="disallowed_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix/mix:BasicImageInformation/mix:SpecialFormatCharacteristics/mix:JPEG2000"/>
		<sch:param name="mdtype_name" value="string('NISOIMG (MIX)')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
		
	<!-- TIFF specific check -->
	<sch:pattern id="mix_byteOrder" is-a="required_element_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('image/tiff')"/>
		<sch:param name="required_element" value="mets:techMD/mets:mdWrap/mets:xmlData/mix:mix/mix:BasicDigitalObjectInformation/mix:byteOrder"/>
		<sch:param name="mdtype_name" value="string('NISOIMG (MIX)')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>


</sch:schema>
