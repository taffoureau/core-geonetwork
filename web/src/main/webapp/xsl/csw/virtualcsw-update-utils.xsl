<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template mode="script" match="/" name="user-admin-js"></xsl:template>
	
	<xsl:template name="virtualcswinfofields">
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswAny"/></th>
					<td class="padded"><input class="content" type="text" name="any" value="{/root/gui/services/filter/any}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswTitle"/></th>
					<td class="padded"><input class="content" type="text" name="title" value="{/root/gui/services/filter/title}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswAbstract"/></th>
					<td class="padded"><input class="content" type="text" name="abstract" value="{/root/gui/services/filter/abstract}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswKeywords"/></th>
					<td class="padded"><input class="content" type="text" name="keyword" value="{/root/gui/services/filter/keyword}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswDenominatorFrom"/></th>
					<td class="padded"><input class="content" type="text" name="denominatorFrom" value="{/root/gui/services/filter/denominatorFrom}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswDenominatorTo"/></th>
					<td class="padded"><input class="content" type="text" name="denominatorTo" value="{/root/gui/services/filter/denominatorTo}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswType"/></th>
					<td class="padded"><input class="content" type="text" name="type" value="{/root/gui/services/filter/type}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswCatalog"/></th>
					<td class="padded"><input class="content" type="text" name="catalog" value="{/root/gui/services/filter/catalog}"/></td>
				</tr>
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswGroup"/></th>
					<td class="padded"><input class="content" type="text" name="group" value="{/root/gui/services/filter/group}"/></td>
				</tr>
								

	</xsl:template>
	
</xsl:stylesheet>

