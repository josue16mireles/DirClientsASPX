<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="Polizas.aspx.cs" Inherits="dir_clients.Polizas" %>
<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Content/GridView.css") %>' />
    <script type="text/javascript" src='<%# ResolveUrl("~/Content/GridView.js") %>'></script>
</asp:Content>

<%--<asp:Content ContentPlaceHolderID="LeftPanelContent" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderID="RightPanelContent" runat="server">
</asp:Content>--%>

<asp:Content ContentPlaceHolderID="PageToolbar" runat="server">
    <dx:ASPxMenu runat="server" ID="PageToolbar" ClientInstanceName="pageToolbar"
        ItemAutoWidth="false" ApplyItemStyleToTemplates="true" ItemWrap="false"
        AllowSelectItem="false" SeparatorWidth="0"
        Width="100%" CssClass="page-toolbar">
        <ClientSideEvents ItemClick="onPageToolbarItemClick" />
        <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="true"
            EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="600" />
        <ItemStyle CssClass="item" VerticalAlign="Middle" />
        <ItemImage Width="16px" Height="16px" />
        <Items>
            <dx:MenuItem Enabled="false">
                <Template>
                    <h1>Polizas</h1>
                </Template>
            </dx:MenuItem>
            <dx:MenuItem Name="New" Text="New" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/add.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Edit" Text="Edit" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/edit.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Delete" Text="Delete" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/delete.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Export" Text="Export" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/export.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="ToggleFilterPanel" Text="" GroupName="Filter" Alignment="Right" AdaptivePriority="1">
                <Image Url="Content/Images/search.svg" UrlChecked="Content/Images/search-selected.svg" />
            </dx:MenuItem>
        </Items>
    </dx:ASPxMenu>
    <dx:ASPxPanel runat="server" ID="FilterPanel" ClientInstanceName="filterPanel" Collapsible="True" CssClass="filter-panel">
        <SettingsCollapsing ExpandEffect="PopupToBottom" AnimationType="Fade" ExpandButton-Visible="false" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxButtonEdit runat="server" ID="SearchButtonEdit" ClientInstanceName="searchButtonEdit" ClearButton-DisplayMode="Always" Caption="Search" Width="100%" />
            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents Expanded="onFilterPanelExpanded" Collapsed="adjustPageControls" />
    </dx:ASPxPanel>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="PageContent" runat="server">
    <dx:EntityServerModeDataSource ID="dsPolizas" runat="server" EnableInsert="true" EnableUpdate="true" EnableDelete="True"  OnSelecting="dsPolizas_Selecting" OnInserting="dsPolizas_Inserting" OnUpdating="dsPolizas_Updating" ContextTypeName="ClientsDataModel" TableName="vpoliza" />
    <asp:SqlDataSource ID="dsClients" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_client, nombre FROM vclients order by nombre" />
    <asp:SqlDataSource ID="dsCpy" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select uid_company, company from dbo.vcompany order by company" />
    <asp:SqlDataSource ID="dsProdPol" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select uid_prodpol, prodpol from dbo.vprodpol order by prodpol" />
    
    <dx:ASPxGridView runat="server" ID="GridView" ClientInstanceName="gridView" KeyFieldName="uid_poliza" KeyboardSupport="True" EnablePagingGestures="False" Width="100%"
        DataSourceID="dsPolizas"
        OnRowUpdating="GridView_RowUpdating" OnRowInserting="GridView_RowInserting" OnRowDeleting="GridView_RowDeleting" AutoGenerateColumns="False"
        OnCustomErrorText="GridView_CustomErrorText" 
        OnCellEditorInitialize="GridView_CellEditorInitialize">
        
        <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" /> 

        <SettingsResizing ColumnResizeMode="Control" />
        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
        <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
        <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
        <Settings VerticalScrollBarMode="auto" VerticalScrollableHeight="730" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true"/>
        <SettingsPager PageSize="200" EnableAdaptivity="true">
            <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
        </SettingsPager>
        <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
        <SettingsPopup>
            <EditForm>
                <SettingsAdaptivity MaxWidth="800" Mode="Always" VerticalAlign="WindowCenter" />
            </EditForm>
            <FilterControl AutoUpdatePosition="False"></FilterControl>
        </SettingsPopup>
        <Styles>
            <Cell Wrap="false" />
            <PagerBottomPanel CssClass="pager" />
            <FocusedRow CssClass="focused" />
        </Styles>
        <Paddings PaddingTop="0px" />
        
        <EditFormLayoutProperties UseDefaultPaddings="false">
            <Items>
                <dx:GridViewLayoutGroup ColSpan="1" ColCount="2" ColumnCount="2" ShowCaption="False" >
                    <Items>
                        <dx:GridViewColumnLayoutItem Caption="Nombre" ColSpan="1" ColumnName="nombre">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Poliza" ColSpan="1" ColumnName="no_poliza">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Fech. Ini." ColSpan="1" ColumnName="fech_inicio">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Tipo de Pago" ColSpan="1" ColumnName="FrecuenciaDePago">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Compañia" ColSpan="1" ColumnName="company">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Producto" ColSpan="1" ColumnName="prodpol">
                        </dx:GridViewColumnLayoutItem>
                        <dx:EditModeCommandLayoutItem ColSpan="2" HorizontalAlign="Right">
                        </dx:EditModeCommandLayoutItem>
                    </Items>
                </dx:GridViewLayoutGroup>
            </Items>
        </EditFormLayoutProperties>
        <Columns>
            
            <dx:GridViewDataTextColumn FieldName="uid_poliza" ReadOnly="True" Visible="False" VisibleIndex="0">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn Caption="Nombre" FieldName="nombre" ShowInCustomizationForm="True" VisibleIndex="2" Width="400px">
                <PropertiesComboBox ValueField="uid_client" TextField="nombre" DataSourceID="dsClients"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="uid_client" ReadOnly="True" Visible="False" VisibleIndex="1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Poliza" FieldName="no_poliza" VisibleIndex="3" ShowInCustomizationForm="true" Width="200">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataDateColumn Caption="Fech. Ini." FieldName="fech_inicio" VisibleIndex="4" ShowInCustomizationForm="true" Width="200">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataDateColumn Caption="Vencimiento" FieldName="fech_vencimiento" VisibleIndex="5" ShowInCustomizationForm="true" Width="200">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataComboBoxColumn Caption="Frec. Pago" FieldName="FrecuenciaDePago" VisibleIndex="6" ShowInCustomizationForm="true" Width="200">
                <PropertiesComboBox>
                    <Items>
                        <dx:ListEditItem Text="Mensual" Value="1" />
                        <dx:ListEditItem Text="Trimestral" Value="2" />
                        <dx:ListEditItem Text="Semestral" Value="3" />
                        <dx:ListEditItem Text="Anual" Value="4" />
                    </Items>
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataDateColumn Caption="Sig. Pago" FieldName="nxt_pago" VisibleIndex="7" ShowInCustomizationForm="true" Width="200">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataTextColumn FieldName="uid_prod_pol" ReadOnly="True" Visible="False" VisibleIndex="8">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn Caption="Producto" FieldName="uid_prod_pol" VisibleIndex="9" ShowInCustomizationForm="true" Width="300">
                <PropertiesComboBox ValueField="uid_prodpol" TextField="prodpol" EnableSynchronization="False" DataSourceID="dsProdPol" TextFormatString="{0}"  LoadDropDownOnDemand="true" ValueType="System.Guid">
                    <ClientSideEvents EndCallback="onProdPolEndCallback" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="tipo_pago" ReadOnly="True" Visible="False" VisibleIndex="10">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="uid_company" ReadOnly="True" Visible="False" VisibleIndex="11">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn Caption="Compañia" FieldName="uid_company" VisibleIndex="12" ShowInCustomizationForm="true" Width="200">
                <PropertiesComboBox TextField="company" ValueField="uid_company" DataSourceID="dsCpy" LoadDropDownOnDemand="True" >
                    <ClientSideEvents SelectedIndexChanged="onSelectedCpyChanged" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            
        </Columns>

    </dx:ASPxGridView>
</asp:Content>
