<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="Polizas.aspx.cs" Inherits="dir_clients.Polizas" %>
<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<%--<%@ Register Src="~/NewCpyProd.ascx" TagName="AvailableCpyProd" TagPrefix="CPs" %>--%>

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

            pageToolbar.GetItemByName("Edit").SetEnabled(gridView.GetFocusedRowIndex() !== -1);
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
                case "NewCpyProd":
                    //ShowWindow(CPs_PopupControl, 0, 'Compañias y Productos');
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
        //function OnComboBoxInit(s, e) {
        //    // Personalizar el contenido de la celda con un enlace (hyperlink)
        //    var comboBox = s;
        //    comboBox.GetGridView().GetValuesOnCustomCallback = function (args) {
        //        var index = args.visibleIndex;
        //        var clienteGuid = comboBox.GetRowKey(index);
        //        var clienteTexto = comboBox.GetRow(index).cells["uid_client"].innerText;
        //        return clienteTexto + '<a href="Client_Edit.aspx?clienteGuid=' + clienteGuid + '">Enlace</a>';
        //    };
        //}
        function edicion() {
            gridView.GetRowValues(gridView.GetFocusedRowIndex(), 'uid_client', OpenEdit);
        }
        function OpenEdit(values) {
            var _edit = "Editar|" + values;
            cbpage.PerformCallback(_edit);
        }
        function cbpageCallbackComplete(s, e) {
            var x = e.result.split("|");
            switch (x[0]) {
                //case 'Nuevo':
                //    window.location.href = "Client_Edit.aspx";
                //    break;
                case 'Editar':
                    window.location.href = "Client_Edit.aspx";
                    break;
                case 'Error':
                    alert(x[1]);
                    break;
                default:
                    gridView.PerformCallback();
                    break;
            }
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
        function onGridEndCallback(s, e) {
            lastEditedCpy = -1;
        }
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

        //function OnMoreInfoClick(contentUrl) {
        //    clientPopupControl.SetContentUrl(contentUrl);
        //    clientPopupControl.Show();
        //}

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
                    <h1>Polizas</h1>
                </Template>
            </dx:MenuItem>
            <dx:MenuItem Name="New" Text="New" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/add.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Edit" Text="Edit" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/edit.svg" />
            </dx:MenuItem>
            <%--<dx:MenuItem Name="Delete" Text="Delete" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/delete.svg" />
            </dx:MenuItem>--%>
            <dx:MenuItem Name="Export" Text="Export" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/export.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="NewCpyProd" Text="Compañias" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/add.svg" />
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
     <dx:ASPxPopupControl ID="CPs_PopupControl" runat="server" AllowDragging="false" ClientInstanceName="CPs_PopupControl" Modal="True" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="250px" Height="100px">
        <Windows>
            <dx:PopupWindow CloseAction="CloseButton" CloseOnEscape="True" HeaderText="Cpy_Prod" Modal="True"  Name="CPs_PopupControlWindow" ScrollBars="None" >
                <ContentCollection>
                   <dx:PopupControlContentControl runat="server">
                        <%--<CPs:AvailableCpyProd ID="CPsCpyProd" ClientInstanceName="CPsCpyProd" runat="server" />--%>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:PopupWindow>
        </Windows>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxCallback ID="cbpage" ClientInstanceName="cbpage" runat="server" OnCallback="cbpage_Callback">
        <ClientSideEvents CallbackComplete="cbpageCallbackComplete" />
    </dx:ASPxCallback>
    <dx:EntityServerModeDataSource ID="dsPolizas" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="dsPolizas_Selecting" OnInserting="dsPolizas_Inserting" OnUpdating="dsPolizas_Updating" ContextTypeName="ClientsDataModel" TableName="vpoliza" />
    <asp:SqlDataSource ID="dsClients" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_client, nombre FROM vclients order by nombre" />
    <asp:SqlDataSource ID="dsProdPol" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select uid_prodpol, prodpol from dbo.vprodpol" />
    <asp:SqlDataSource ID="dsCpy" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_company, company FROM dbo.vcompany ORDER BY company"/>
    
    <dx:ASPxLoadingPanel runat="server" ID="loadingPanel" ClientInstanceName="lp" Modal="true" />
    <dx:ASPxGridView runat="server" ID="GridView" ClientInstanceName="gridView" KeyFieldName="uid_poliza" KeyboardSupport="True" EnablePagingGestures="False" Width="100%"
        DataSourceID="dsPolizas"
        OnRowUpdating="GridView_RowUpdating" OnRowInserting="GridView_RowInserting" AutoGenerateColumns="False" OnCellEditorInitialize="GridView_CellEditorInitialize"
        OnCustomErrorText="GridView_CustomErrorText">
        <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" BatchEditStartEditing="onBatchEditStartEditing" EndCallback="onGridEndCallback" FocusedCellChanging="onFocusedCellChanging" />
        <SettingsDataSecurity AllowReadUnlistedFieldsFromClientApi="True" />
        <SettingsResizing ColumnResizeMode="Control" />
        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
        <SettingsEditing Mode="Batch" UseFormLayout="false" NewItemRowPosition="Bottom">
            <BatchEditSettings EditMode="Row"  />
        </SettingsEditing> 
        <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
        <Settings VerticalScrollBarMode="auto" VerticalScrollableHeight="730" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true"/>
        <SettingsPager PageSize="200" EnableAdaptivity="true">
            <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
        </SettingsPager>
        <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
        <Styles>
            <Cell Wrap="false" />
            <PagerBottomPanel CssClass="pager" />
            <FocusedRow CssClass="focused" />
        </Styles>
        <Paddings PaddingTop="0px" />
        <Columns>
            <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="13" FixedStyle="Left" Width="52"></dx:GridViewCommandColumn>
            <dx:GridViewDataTextColumn FieldName="uid_poliza" ReadOnly="True" Visible="False" VisibleIndex="0">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn Caption="Nombre" FieldName="uid_client" ShowInCustomizationForm="True" VisibleIndex="2" Width="350px">
                <PropertiesComboBox ValueField="uid_client" TextField="nombre" DataSourceID="dsClients">
                    <%--<ClientSideEvents Init="function(s, e) { OnComboBoxInit(s, e); }" />--%>
                </PropertiesComboBox>
                <%--<DataItemTemplate>
                    <dx:ASPxHyperLink id="linkclient" runat="server" OnInit="linkclient_Init" ></dx:ASPxHyperLink>
                </DataItemTemplate>--%>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="uid_client" ReadOnly="True" Visible="False" VisibleIndex="1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Poliza" FieldName="no_poliza" VisibleIndex="3" ShowInCustomizationForm="true" Width="150">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataDateColumn Caption="Fech. Ini." FieldName="fech_inicio" VisibleIndex="4" ShowInCustomizationForm="true" Width="120">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataTextColumn Caption="Vencimiento" FieldName="fech_vencimiento" VisibleIndex="5" ReadOnly="true" ShowInCustomizationForm="true" Width="120">
                 <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn Caption="Frec. Pago" FieldName="tipo_pago" VisibleIndex="6" ShowInCustomizationForm="true" Width="150">
                <PropertiesComboBox>
                    <Items>
                        <dx:ListEditItem Text="Mensual" Value="1" />
                        <dx:ListEditItem Text="Trimestral" Value="2" />
                        <dx:ListEditItem Text="Semestral" Value="3" />
                        <dx:ListEditItem Text="Anual" Value="4" />
                    </Items>
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn Caption="Sig. Pago" FieldName="nxt_pago" VisibleIndex="7" ReadOnly="true" ShowInCustomizationForm="true" Width="120">
                 <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
            </dx:GridViewDataTextColumn>

            <dx:GridViewDataComboBoxColumn Caption="Compañia" FieldName="uid_company" ShowInCustomizationForm="true" VisibleIndex="8"  Width="200">
                <PropertiesComboBox ClientInstanceName="cbCpyProd" TextField="company" ValueField="uid_company" ValueType="System.String" EnableSynchronization="false" DataSecurityMode="Strict" 
                    IncrementalFilteringMode="StartsWith" DataSourceID="dsCpy">
                    <ClientSideEvents SelectedIndexChanged="onSelectedCpyChanged" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataComboBoxColumn Caption="Producto" FieldName="uid_prodpol" VisibleIndex="9" ShowInCustomizationForm="true" Width="300">
                <PropertiesComboBox EnableSynchronization="false" IncrementalFilteringMode="StartsWith" ClientInstanceName="cmbProd" DataSourceID="dsProdPol" TextField="prodpol" ValueField="uid_prodpol" ValueType="System.String" DataSecurityMode="Strict" >
                <ClientSideEvents EndCallback="onProdEndCallback" BeginCallback="onBeginCallback" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>

            <dx:GridViewDataTextColumn Caption="Estatus" FieldName="estatus" CellStyle-HorizontalAlign="Center" ReadOnly="true" VisibleIndex="10" Width="90" >
                <%--<DataItemTemplate>
                    <span class="status-column" <%# Eval("estatus")  %>" > </span>
                </DataItemTemplate>--%>
<CellStyle HorizontalAlign="Center"></CellStyle>
            </dx:GridViewDataTextColumn>
            
        </Columns>

    </dx:ASPxGridView>
</asp:Content>
