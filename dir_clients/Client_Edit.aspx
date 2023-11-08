<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="Client_Edit.aspx.cs" Inherits="dir_clients.Client_Edit" %>

<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Content/GridView.css") %>' />
    <%--<script type="text/javascript" src='<%# ResolveUrl("~/Content/GridView.js") %>'></script>--%>
</asp:Content>
<asp:Content ContentPlaceHolderID="PageToolbar" runat="server">
    <script type="text/javascript">

        function onGridViewInit(s, e) {
            AddAdjustmentDelegate(adjustGridView);
            updateToolbarButtonsState();
            AdjustSize(); //ajusta el tamaño del grid segun el tamaño de la pantalla
        }
        function AdjustSize() {
            var height = Math.max(0, document.documentElement.clientHeight);
            //grid.SetHeight(height);
            gridView.SetHeight(height);
        }

        function onGridViewSelectionChanged(s, e) {
            updateToolbarButtonsState();
        }
        function adjustGridView() {
            gridView.AdjustControl();
        }
        function updateToolbarButtonsState() {
            var enabled = gridView.GetSelectedRowCount() > 0;
            pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
            pageToolbar.GetItemByName("Export").SetEnabled(enabled);

        }
        function onPageToolbarItemClick(s, e) {
            switch (e.item.name) {
                case "ToggleFilterPanel":
                    toggleFilterPanel();
                    break;
                case "Save":
                    if (!(HasChanges()))
                        return;
                    _savecancel(true);
                    break;
                case "Cancel":
                    if (HasChanges()) {
                        _savecancel(false);
                    }
                    else {
                        return;
                    }
                    break;
                case "New":
                    gridView.AddNewRow();
                    break;
                case "Delete":
                    deleteSelectedRecords();
                    break;
                case "Export":
                    gridView.ExportTo(ASPxClientGridViewExportFormat.Xlsx);
                    break;
            }
        }
        function deleteSelectedRecords() {
            if (confirm('Confirm Delete?')) {
                gridView.PerformCallback('delete');
            }
        }
        function toggleFilterPanel() {
            filterPanel.Toggle();
        }

        function onFilterPanelExpanded(s, e) {
            adjustPageControls();
            searchButtonEdit.SetFocus();
        }
        /**PARA GUARDAR CAMBIOS DE CARDVIEW Y GRIDVIEW EN EL Client_Edit**/
        function HasChanges() {
            return (cvClientEdit.batchEditApi.HasChanges() || gridView.batchEditApi.HasChanges());
        }
        function _savecancel(_cambios) {
            if (_cambios) {
                cvClientEdit.UpdateEdit();
                gridView.UpdateEdit();
            } else {
                cvClientEdit.CancelEdit();
                gridView.CancelEdit();
            }
        }
        function OnEndCallback(s, e) {
            if (!HasChanges()) {
                //loadingpanel.Hide();
            }
        }
        /**PARA GUARDAR CAMBIOS DE CARDVIEW Y GRIDVIEW EN EL Client_Edit**/
    </script>
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
                    <h1>Cliente</h1>
                </Template>
            </dx:MenuItem> 
            <dx:MenuItem Name="Save" Text="Guardar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/save.svg" />
            </dx:MenuItem>
             <dx:MenuItem Name="Cancel" Text="Cancelar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/cancel.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="New" Text="New" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/add.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Delete" Text="Delete" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/delete.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Edit" Text="Edit" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/edit.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Export" Text="Export" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/export.svg" />
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
    <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" UseDefaultPaddings="False">
        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" GridSettings-StretchLastItem="True">
            <GridSettings StretchLastItem="True"></GridSettings>
        </SettingsAdaptivity>
        <Items>
            <dx:LayoutItem ColSpan="1" ShowCaption="False" Width="100%">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                         <dx:EntityServerModeDataSource ID="esmdClient" runat="server" OnSelecting="esmdClient_Selecting" OnUpdating="esmdClient_Updating" />
                         <dx:ASPxCardView ID="cvClientEdit" ClientInstanceName="cvClientEdit" runat="server" 
                            DataSourceID="esmdClient" KeyFieldName="uid_client" AutoGenerateColumns="False"
                            OnCardUpdating="cvClientEdit_CardUpdating" OnCustomErrorText="cvClientEdit_CustomErrorText" Border-BorderStyle="Solid">
                            <ClientSideEvents EndCallback="OnEndCallback" />
                            <SettingsPager Visible="False"/>
                            <SettingsEditing Mode="Batch">
                                <BatchEditSettings EditMode="Card" StartEditAction="DblClick" />
                            </SettingsEditing>
                            <Settings LayoutMode="Flow" ShowStatusBar="Hidden"/>
                            <SettingsAdaptivity>
                                <BreakpointsLayoutSettings CardsPerRow="1" >
                                </BreakpointsLayoutSettings>
                            </SettingsAdaptivity>
                            <SettingsCommandButton>
                                <UpdateButton Text=" "/>
                                <CancelButton Text=" "/>
                            </SettingsCommandButton>
                            <SettingsDataSecurity AllowDelete="False" AllowInsert="False" AllowReadUnlistedFieldsFromClientApi="True" />
                            <SettingsBehavior AllowFocusedCard="true" AllowSelectByCardClick="true" AllowSelectSingleCardOnly="true" />

                            <SettingsExport ExportSelectedCardsOnly="False"/>

                            <Columns>
                                <dx:CardViewTextColumn FieldName="uid_client" ReadOnly="True" Visible="False" VisibleIndex="0">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Nombre" FieldName="nombre" VisibleIndex="1">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Direccion" FieldName="direccion" VisibleIndex="2">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Telefono" FieldName="telefono" VisibleIndex="3">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Celular" FieldName="celular" VisibleIndex="4">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Email" FieldName="email" VisibleIndex="5">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Email 2" FieldName="email2" VisibleIndex="6">
                                </dx:CardViewTextColumn>
                                <dx:CardViewMemoColumn Caption="Relacionado" FieldName="relacionado" VisibleIndex="7">
                                    <PropertiesMemoEdit>
			                            <Style Font-Size="Small" Wrap="True"/>
		                            </PropertiesMemoEdit>
		                            <BatchEditModifiedCellStyle Wrap="False">
		                            </BatchEditModifiedCellStyle>
                                </dx:CardViewMemoColumn>
                                <dx:CardViewMemoColumn Caption="Archivero" FieldName="archivero" VisibleIndex="8">
                                    <PropertiesMemoEdit>
			                            <Style Font-Size="Small" Wrap="True"/>
		                            </PropertiesMemoEdit>
		                            <BatchEditModifiedCellStyle Wrap="False">
		                            </BatchEditModifiedCellStyle>
                                </dx:CardViewMemoColumn>
                            </Columns>

                            <CardLayoutProperties ColCount="4" ColumnCount="4">
                                <Items>
                                    <dx:CardViewColumnLayoutItem Caption="Nombre" ColSpan="1" ColumnName="Nombre" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Direccion" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Telefono" Width="270px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Relacionado" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Email" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Email 2" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Celular" Width="270px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Archivero" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                </Items>
                            </CardLayoutProperties>

                           <Styles>
                                <Card Border-BorderStyle="None" Height="100%" HorizontalAlign="Left" VerticalAlign="Top" Width="30%" Wrap="True">
                                    <Border BorderStyle="None"></Border>
                                </Card>
                                <FlowCard Height="30%" Width="99%" HorizontalAlign="Left" VerticalAlign="Top" Wrap="True">
                                </FlowCard>
                                <Table  HorizontalAlign="Left" VerticalAlign="Top" Wrap="True">
        
                                </Table>
                            </Styles>
                            <StylesExport>
                                <Card BorderSize="1" BorderSides="All"></Card>
                                <Group BorderSize="1" BorderSides="All"></Group>
                                <TabbedGroup BorderSize="1" BorderSides="All"></TabbedGroup>
                                <Tab BorderSize="1"></Tab>
                            </StylesExport>

                            <Border BorderStyle="Solid"></Border>
        
                        </dx:ASPxCardView>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
            <dx:LayoutItem ColumnSpan="1" HorizontalAlign="Center" ShowCaption="False" Width="100%">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                        <dx:ASPxCallbackPanel ID="cpGrid" runat="server" Width="100%" ClientInstanceName="cpGrid">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <dx:EntityServerModeDataSource ID="esmdPolizasClient" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="esmdPolizasClient_Selecting" OnInserting="esmdPolizasClient_Inserting"  OnUpdating="esmdPolizasClient_Updating"/>
                                    <asp:SqlDataSource ID="dsCpy" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select uid_company, company from dbo.vcompany order by company" />
                                    <asp:SqlDataSource ID="dsProdPol" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select uid_prodpol, prodpol from dbo.vprodpol order by prodpol" />
                                    <dx:ASPxGridView ID="GridView" runat="server" AutoGenerateColumns="false" ClientInstanceName="gridView" 
                                        DataSourceID="esmdPolizasClient" KeyFieldName="uid_poliza" 
                                        OnCustomCallback="GridView_CustomCallback" OnRowInserting="GridView_RowInserting" 
                                        OnRowUpdating="GridView_RowUpdating" OnCustomErrorText="GridView_CustomErrorText" 
                                        OnCommandButtonInitialize="GridView_CommandButtonInitialize">

                                       <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" EndCallback="OnEndCallback"  /> 
                                        <SettingsResizing ColumnResizeMode="Control" />
                                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
                                        <SettingsEditing Mode="Batch" UseFormLayout="false" NewItemRowPosition="Bottom">
                                            <BatchEditSettings EditMode="Row" StartEditAction="DblClick" />
                                        </SettingsEditing>   
                                        <Settings VerticalScrollBarMode="auto" VerticalScrollableHeight="620" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true"/>
                                        <SettingsPager PageSize="100" EnableAdaptivity="true">
                                            <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                                        </SettingsPager>
                                        <SettingsCookies StorePaging="False" />
                                        <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
                                        <Styles>
                                            <Cell Wrap="false" />
                                            <PagerBottomPanel CssClass="pager" />
                                            <FocusedRow CssClass="focused" />
                                        </Styles>
                                        <Paddings PaddingTop="0px" />

                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="uid_poliza" ShowInCustomizationForm="true" Visible="false" VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="no_poliza" Caption="Poliza" ShowInCustomizationForm="true" Visible="true" VisibleIndex="2" Width="270px">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="fech_inicio" Caption="Fech Ini." ShowInCustomizationForm="true" Visible="true" VisibleIndex="3" Width="270px">
                                                <Settings AllowFilterBySearchPanel="True" AllowHeaderFilter="False" AutoFilterCondition="Contains" FilterMode="DisplayText" ShowInFilterControl="True" />
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn FieldName="fech_vencimiento" Caption="Vencimiento" ReadOnly="true" ShowInCustomizationForm="true" Visible="true" VisibleIndex="4" Width="270px">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="tipo_pago" Caption="Frec. Pago" ShowInCustomizationForm="true" Visible="true" VisibleIndex="5" Width="270px">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Mensual" Value="1" />
                                                        <dx:ListEditItem Text="Trimestral" Value="2" />
                                                        <dx:ListEditItem Text="Semestral" Value="3" />
                                                        <dx:ListEditItem Text="Anual" Value="4" />
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataDateColumn FieldName="nxt_pago" Caption="Sig. Pago" ReadOnly="true" ShowInCustomizationForm="true" Visible="true" VisibleIndex="6" Width="270px">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="uid_prod_pol" Caption="Producto" ShowInCustomizationForm="true" Visible="true" VisibleIndex="7" Width="270px">
                                                <PropertiesComboBox DataSourceID="dsProdPol" TextField="prodpol" ValueField="uid_prodpol"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="uid_company" Caption="Compañia" ShowInCustomizationForm="true" Visible="true" VisibleIndex="8" Width="270px">
                                                <PropertiesComboBox DataSourceID="dsCpy" TextField="company" ValueField="uid_company"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>

                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
        </Items>
    </dx:ASPxFormLayout>
</asp:Content>
