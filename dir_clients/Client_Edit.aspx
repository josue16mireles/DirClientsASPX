<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="Client_Edit.aspx.cs" Inherits="dir_clients.Client_Edit" %>

<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Content/GridView.css") %>' />
    <%--<script type="text/javascript" src='<%# ResolveUrl("~/Content/GridView.js") %>'></script>--%>
    <script type="text/javascript">

        function onGridViewInit(s, e) {
            AddAdjustmentDelegate(adjustGridView);
            updateToolbarButtonsState();
            AdjustSize(); //ajusta el tamaño del grid segun el tamaño de la pantalla
        }
        function AdjustSize() {
            var height = Math.max(0, document.documentElement.clientHeight);
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
            //pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
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
                case "Edit":
                    gridView.StartEditRow(gridView.GetFocusedRowIndex());
                    break;
                //case "Delete":
                //    deleteSelectedRecords();
                //    break;
                case "Export":
                    gridView.ExportTo(ASPxClientGridViewExportFormat.Xlsx);
                    break;
            }
        }
        //function deleteSelectedRecords() {
        //    if (confirm('Confirm Delete?')) {
        //        gridView.PerformCallback('delete');
        //    }
        //}
        function onFiltersNavBarItemClick(s, e) {
            var filters = {
                All: "",
                Active: "[estatus] = 'activa' ",
                Vencida: "[estatus] = 'vencida' ",

            };
            gridView.ApplyFilter(filters[e.item.name]);
            HideLeftPanelIfRequired();
        }
        function toggleFilterPanel() {
            filterPanel.Toggle();
        }

        function onFilterPanelExpanded(s, e) {
            adjustPageControls();
            searchButtonEdit.SetFocus();
        }
        /**PARA GUARDAR O LIMPIAR CAMBIOS DE CARDVIEW Y GRIDVIEW EN EL Client_Edit**/
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
            }
            lastEditedCpy = -1;
        }
        /**PARA GUARDAR O LIMPIAR CAMBIOS DE CARDVIEW Y GRIDVIEW EN EL Client_Edit**/

        /**FILTRA EL COMBOBOX DE PRODUCTO CONFORME A LA SELECCION DEL COMBOBOX COMPANY**/
        var currentRowIndex = -1;
        var currentColumnIndex = -1;
        var lastEditedCpy = -1;

        function onBatchEditStartEditing(s, e) {
            currentRowIndex = e.visibleIndex;
            currentColumnIndex = e.focusedColumn.index;
            var currentCpy = s.batchEditApi.GetCellValue(currentRowIndex, "uid_company");
            if (currentCpy != lastEditedCpy && e.focusedColumn.fieldName == "uid_prodpol") {
                lastEditedCpy = currentCpy;
                e.cancel = true;
                cmbProd.PerformCallback(lastEditedCpy);
            }
        }
        function onSelectedCpyChanged(s, e) {
            lastEditedCpy = s.GetValue();
            gridView.batchEditApi.SetCellValue(currentRowIndex, "uid_prodpol", null);
            cmbProd.PerformCallback(s.GetValue());
        }
        //function onGridEndCallback(s, e) {
        //    lastEditedCpy = -1;
        //}
        function onFocusedCellChanging(s, e) {
            e.cancel = cmbProd.InCallback();
        }
        function onProdEndCallback(s, e) {
            lp.Hide();
            gridView.batchEditApi.StartEdit(currentRowIndex, currentColumnIndex);
        }
        function onBeginCallback(s, e) {
            window.setTimeout(function () {
                if (cmbProd.InCallback()) lp.ShowInElement(gridView.batchEditApi.GetCellTextContainer(currentRowIndex, "uid_prodpol"));
            }, 300);
        }
        /**FILTRA EL COMBOBOX DE PRODUCTO CONFORME A LA SELECCION DEL COMBOBOX COMPANY**/

    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="LeftPanelContent" runat="server">
    
     <h3 class="leftpanel-section section-caption">Filtros</h3>
    <dx:ASPxNavBar runat="server" ID="FiltersNavBar" ClientInstanceName="filtersNavBar"
        AllowSelectItem="true" ShowGroupHeaders="false"
        Width="100%" CssClass="filters-navbar">
        <ItemStyle CssClass="item" />
        <Groups>
            <dx:NavBarGroup>
                <Items>
                    <dx:NavBarItem Text="Todas las polizas" Selected="true" Name="All" />
                    <dx:NavBarItem Text="Polizas activas" Name="Active" />
                    <dx:NavBarItem Text="Polizas vencidas" Name="Vencida" />
                </Items>
            </dx:NavBarGroup>
        </Groups>
        <ClientSideEvents ItemClick="onFiltersNavBarItemClick" />
    </dx:ASPxNavBar>
</asp:Content>
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
            <%--<dx:MenuItem Name="Delete" Text="Delete" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/delete.svg" />
            </dx:MenuItem>--%>
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
    <dx:ASPxLoadingPanel runat="server" ID="loadingPanel" ClientInstanceName="lp" Modal="true" />
    <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" UseDefaultPaddings="False">
        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" GridSettings-StretchLastItem="True">
            <GridSettings StretchLastItem="True"></GridSettings>
        </SettingsAdaptivity>
        <Items>
            <dx:LayoutItem ColSpan="1" HorizontalAlign="Center" ShowCaption="False">
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
                            <SettingsDataSecurity AllowInsert="False" AllowReadUnlistedFieldsFromClientApi="True" />
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
                               <%--<Card CssClass="card" Width="250"></Card>--%>
                                <%--<Card Border-BorderStyle="None" Height="100%" HorizontalAlign="Left" VerticalAlign="Top" Width="30%" Wrap="True">
                                    <Border BorderStyle="None"></Border>
                                </Card>--%>
                                <FlowCard Height="30%" Width="90%" >
                                </FlowCard>
                                <Table HorizontalAlign="Left" VerticalAlign="Top" Wrap="True">
                                    
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
            <dx:LayoutItem ColumnSpan="1" HorizontalAlign="Center" ShowCaption="False" Width="85%">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                        <dx:ASPxCallbackPanel ID="cpGrid" runat="server" Width="100%" ClientInstanceName="cpGrid">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <dx:EntityServerModeDataSource ID="esmdPolizasClient" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="esmdPolizasClient_Selecting" OnInserting="esmdPolizasClient_Inserting" OnUpdating="esmdPolizasClient_Updating"/>
                                    <asp:SqlDataSource ID="dsProdPol" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select uid_prodpol, prodpol from dbo.vprodpol" />
                                    <asp:SqlDataSource ID="dsCpy" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_company, company FROM dbo.vcompany ORDER BY company"/>
                                    
                                    <dx:ASPxLoadingPanel runat="server" ID="ASPxLoadingPanel1" ClientInstanceName="lp" Modal="true" />
                                    <dx:ASPxGridView ID="GridView" runat="server" AutoGenerateColumns="false" ClientInstanceName="gridView" 
                                        DataSourceID="esmdPolizasClient" KeyFieldName="uid_poliza" 
                                        OnCustomCallback="GridView_CustomCallback" OnRowInserting="GridView_RowInserting" 
                                        OnRowUpdating="GridView_RowUpdating" OnCustomErrorText="GridView_CustomErrorText" 
                                        OnCommandButtonInitialize="GridView_CommandButtonInitialize" OnCellEditorInitialize="GridView_CellEditorInitialize">

                                       <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" BatchEditStartEditing="onBatchEditStartEditing" EndCallback="OnEndCallback" FocusedCellChanging="onFocusedCellChanging" /> 
                                        <SettingsResizing ColumnResizeMode="Control" />
                                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
                                        <SettingsEditing Mode="Batch" UseFormLayout="false" NewItemRowPosition="Bottom">
                                            <BatchEditSettings EditMode="Row" />
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
                                            <dx:GridViewDataTextColumn FieldName="no_poliza" Caption="Poliza" ShowInCustomizationForm="true" Visible="true" VisibleIndex="2" Width="200px">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="fech_inicio" Caption="Fech Ini." ShowInCustomizationForm="true" Visible="true" VisibleIndex="3" Width="200px">
                                                <Settings AllowFilterBySearchPanel="True" AllowHeaderFilter="False" AutoFilterCondition="Contains" FilterMode="DisplayText" ShowInFilterControl="True" />
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="fech_vencimiento" Caption="Vencimiento" ReadOnly="true" ShowInCustomizationForm="true" Visible="true" VisibleIndex="4" Width="200px">
                                                <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="tipo_pago" Caption="Frec. Pago" ShowInCustomizationForm="true" Visible="true" VisibleIndex="5" Width="200px">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Mensual" Value="1" />
                                                        <dx:ListEditItem Text="Trimestral" Value="2" />
                                                        <dx:ListEditItem Text="Semestral" Value="3" />
                                                        <dx:ListEditItem Text="Anual" Value="4" />
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="nxt_pago" Caption="Sig. Pago" ReadOnly="true" ShowInCustomizationForm="true" Visible="true" VisibleIndex="6" Width="270px">
                                                 <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="Compañia" FieldName="uid_company" ShowInCustomizationForm="true" Visible="true" VisibleIndex="7" Width="270px">
                                                <PropertiesComboBox ClientInstanceName="cbCpyProd" TextField="company" ValueField="uid_company" ValueType="System.String" EnableSynchronization="false" DataSecurityMode="Strict" 
                                                    IncrementalFilteringMode="StartsWith" DataSourceID="dsCpy">
                                                    <ClientSideEvents SelectedIndexChanged="onSelectedCpyChanged" />
                                                </PropertiesComboBox>            
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="Producto" FieldName="uid_prodpol" VisibleIndex="8" ShowInCustomizationForm="true" Width="300">
                                                <PropertiesComboBox EnableSynchronization="false" IncrementalFilteringMode="StartsWith" ClientInstanceName="cmbProd" DataSourceID="dsProdPol" TextField="prodpol" ValueField="uid_prodpol" ValueType="System.String" DataSecurityMode="Strict" >
                                                    <ClientSideEvents EndCallback="onProdEndCallback" BeginCallback="onBeginCallback" />
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="Estatus" FieldName="estatus" VisibleIndex="10" Visible="false" CellStyle-HorizontalAlign="Center" Width="90" >
                                            </dx:GridViewDataTextColumn>
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
