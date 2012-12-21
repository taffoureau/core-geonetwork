<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template mode="script" match="/" name="user-admin-js"></xsl:template>
	
	<xsl:template name="virtualcswinfofields">
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/any"/></th>
					<td class="padded"><input class="content" type="text" name="any" value="{/root/response/record/any}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/title"/> (*)</th>
					<td class="padded"><input class="content" type="text" name="title" value="{/root/response/record/title}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/abstract"/></th>
					<td class="padded"><input class="content" type="text" name="abstract" value="{/root/response/record/abstract}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/keyword"/></th>
					<td class="padded"><input class="content" type="text" name="keyword" value="{/root/response/record/keyword}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/denominatorFrom"/></th>
					<td class="padded"><input class="content" type="text" name="denominatorFrom" value="{/root/response/record/denominatorFrom}" size="8"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/denominatorTo"/></th>
					<td class="padded"><input class="content" type="text" name="denominatorTo" value="{/root/response/record/denominatorTo}"/></td>
				</tr>
								

	</xsl:template>
	
</xsl:stylesheet>

