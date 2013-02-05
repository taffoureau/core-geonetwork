<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template mode="script" match="/" name="user-admin-js"></xsl:template>
	
	<xsl:template name="virtualcswinfofields">
	
	<xsl:variable name="lang" select="/root/gui/language"/>
	
	
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
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswCatalog"/></th>
					<td class="padded">
					<select class="content" name="catalog">
							<option value=""/>
							<xsl:for-each select="/root/gui/sources/record">
								<option value="{name}">
									<xsl:variable name="aSource" select="name"/>
									<xsl:if test="/root/gui/services/filter/catalog[.=$aSource]">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="name"/>
								</option>
							</xsl:for-each>
					</select>
					</td>					
				</tr>
				
				<!-- 
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswType"/></th>
					<td class="padded">
					<select class="content" name="type">
							<option value=""/>
							<xsl:for-each select="/root/gui/types/record">
								<xsl:sort select="name"/>
								<option value="{id}">
									<xsl:variable name="aResourceType" select="id"/>
									<xsl:if test="/root/gui/services/filter/type[.=$aResourceType]">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="label/child::*[name() = $lang]"/>
								</option>
							</xsl:for-each>
					</select>
					</td>
				</tr>
				 -->
				
				<tr>
					<th class="padded"><xsl:value-of select="/root/gui/strings/virtualcswGroup"/></th>
					<td class="padded">
					<select class="content" name="group">
							<option value=""/>
							<xsl:for-each select="/root/gui/groups/record">
								<xsl:sort select="name"/>
								<option value="{name}">
									<xsl:variable name="aGroup" select="name"/>
									<xsl:if test="/root/gui/services/filter/group[.=$aGroup]">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="label/child::*[name() = $lang]"/>
								</option>
							</xsl:for-each>
					</select>
					</td>
				</tr>
				
				<!-- 
				<tr>
					<th class="padded">
						<xsl:value-of select="/root/gui/strings/virtualcswCategory"/>
					</th>
					<td class="padded">
					<select class="content" name="category">
							<option value=""/>
							<xsl:for-each select="/root/gui/categories/record">
								<xsl:sort select="name"/>
								<option value="{id}">
									<xsl:variable name="aCategory" select="id"/>
									<xsl:if test="/root/gui/services/filter/category[.=$aCategory]">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="label/child::*[name() = $lang]"/>
								</option>
							</xsl:for-each>
					</select>
					</td>
				</tr>
				-->
				<tr>
					<th class="padded">
						<xsl:value-of select="/root/gui/strings/virtualcswCategory"/>
					</th>
					<td class="padded">
					<select class="content" name="category">
							<option value=""/>
							<xsl:for-each select="/root/gui/categories/record">
								<xsl:sort select="name"/>
								<option value="{name}">
									<xsl:variable name="aCategory" select="name"/>
									<xsl:if test="/root/gui/services/filter/category[.=$aCategory]">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="label/child::*[name() = $lang]"/>
								</option>
							</xsl:for-each>
					</select>
					</td>
				</tr>



	</xsl:template>
	
</xsl:stylesheet>

