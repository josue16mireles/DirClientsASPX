<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="CpyProd.aspx.cs" Inherits="dir_clients.CpyProd" %>

<%@ Register Assembly="DevExpress.Web.v23.2, Version=23.2.13.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Content/GridView.css") %>' />
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
            }
        }
        function toggleFilterPanel() {
            filterPanel.Toggle();
        }
        function onFilterPanelExpanded(s, e) {
            adjustPageControls();
            searchButtonEdit.SetFocus();
        }
        /**PARA GUARDAR O LIMPIAR CAMBIOS DE GRIDVIEW**/
        function HasChanges() {
            return (gridView.batchEditApi.HasChanges());
        }
        function _savecancel(_cambios) {
            if (_cambios) {
                gridView.UpdateEdit();
            } else {
                gridView.CancelEdit();
            }
        }
        //function OnEndCallback(s, e) {
        //    if (!HasChanges()) {
        //    }
        //}
        /**PARA GUARDAR O LIMPIAR CAMBIOS DE GRIDVIEW**/
        //function OnEndCallback(s, e) {
        //    var msg = s.cpErrorMessage;
        //    if (msg) {
        //        alert(msg);
        //        s.cpErrorMessage = null;
        //    }
        //}
        //function onBatchEditEndEditing(s, e) {
        //    var error = s.cpErrorMessage;
        //    if (error)
        //        alert(error);
        //}
        function onCompanyBatchEnd(s, e) {
            // Refrescar gvCpyProds (llama CustomCallback)
            gvCpyProds.PerformCallback();
        }

    </script>
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
                    <h1>Compañias Y Productos</h1>
                </Template>
            </dx:MenuItem>
            <%--<dx:MenuItem Name="Save" Text="Guardar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/save.svg" />
            </dx:MenuItem>
             <dx:MenuItem Name="Cancel" Text="Cancelar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/cancel.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="New" Text="New" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/add.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Edit" Text="Edit" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/edit.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="ToggleFilterPanel" Text="" GroupName="Filter" Alignment="Right" AdaptivePriority="1">
                <Image Url="Content/Images/search.svg" UrlChecked="Content/Images/search-selected.svg" />
            </dx:MenuItem>--%>
        </Items>
    </dx:ASPxMenu>
    <%--<dx:ASPxPanel runat="server" ID="FilterPanel" ClientInstanceName="filterPanel" Collapsible="True" CssClass="filter-panel">
        <SettingsCollapsing ExpandEffect="PopupToBottom" AnimationType="Fade" ExpandButton-Visible="false" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxButtonEdit runat="server" ID="SearchButtonEdit" ClientInstanceName="searchButtonEdit" ClearButton-DisplayMode="Always" Caption="Search" Width="100%" />
            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents Expanded="onFilterPanelExpanded" Collapsed="adjustPageControls" />
    </dx:ASPxPanel>--%>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="PageContent" runat="server">
   <dx:EntityServerModeDataSource ID="dsCompany" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="dsCompany_Selecting" OnInserting="dsCompany_Inserting" OnUpdating="dsCompany_Updating" ContextTypeName="ClientsDataModel" TableName="vcompany" />
   <div style="display: flex; gap: 20px;">

       <dx:ASPxGridView ID="gvCompany" ClientInstanceName="gvCompany" runat="server" DataSourceID="dsCompany" KeyFieldName="uid_company" AutoGenerateColumns="false" Width="45%">
           <ClientSideEvents EndCallback="onCompanyBatchEnd"  />
           <Settings ShowHeaderFilterButton="True" ShowGroupPanel="False" VerticalScrollBarMode="Visible" VerticalScrollableHeight="200"/>
           <SettingsEditing Mode="Batch" />
            <SettingsBehavior AllowDragDrop="false" />
           <Columns>
               <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowCancelButton="true" Width="65px" />
               <dx:GridViewDataTextColumn FieldName="company" Caption="Compañia"></dx:GridViewDataTextColumn>
           </Columns>
       </dx:ASPxGridView>

       <dx:EntityServerModeDataSource ID="dsProduct" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="dsProduct_Selecting" OnInserting="dsProduct_Inserting" OnUpdating="dsProduct_Updating" ContextTypeName="ClientsDataModel" TableName="vproduct" />
       <dx:ASPxGridView ID="gvProductos" runat="server" DataSourceID="dsProduct" KeyFieldName="uid_product" AutoGenerateColumns="false" Width="45%">
          <ClientSideEvents EndCallback="onCompanyBatchEnd" />
           <Settings ShowHeaderFilterButton="True" ShowGroupPanel="False" VerticalScrollBarMode="Visible" VerticalScrollableHeight="200" />
            <SettingsEditing Mode="Batch" />
           <SettingsBehavior AllowDragDrop="false" />
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowCancelButton="true" Width="65px" />
                <dx:GridViewDataTextColumn FieldName="uid_product" ReadOnly="True" Visible="false" VisibleIndex="0">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Producto" Caption="Productos"></dx:GridViewDataTextColumn>
            </Columns>
       </dx:ASPxGridView>
   </div>
    <!-- Línea divisoria -->
    <hr style="margin: 30px 0;" />

    <!-- Tercera tabla -->
    <dx:EntityServerModeDataSource ID="dsCpyProducts" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="dsCpyProducts_Selecting" OnInserting="dsCpyProducts_Inserting" OnUpdating="dsCpyProducts_Updating" ContextTypeName="ClientsDataModel" TableName="vCompany_Products" />
    <asp:SqlDataSource ID="dsCpy" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_company, company FROM dbo.vcompany ORDER BY company"/>
    <asp:SqlDataSource ID="dsProducto" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_product, Producto FROM dbo.vproducts ORDER BY Producto"/>

    <dx:ASPxGridView ID="gvCpyProds" ClientInstanceName="gvCpyProds" runat="server" DataSourceID="dsCpyProducts" KeyFieldName="UID_Principal" 
        AutoGenerateColumns="False" Width="100%" OnCustomCallback="gvCpyProds_CustomCallback" >
        <Settings VerticalScrollableHeight="20" ShowHeaderFilterButton="True" ShowGroupPanel="False" />
        <SettingsEditing Mode="Batch" />
        <SettingsBehavior AllowDragDrop="false" />
        <Columns>
            <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowCancelButton="true" Width="45px" />
            
            <dx:GridViewDataComboBoxColumn FieldName="uid_company" Caption="Compañia">
                <PropertiesComboBox DataSourceID="dsCpy" TextField="company" ValueField="uid_company" ValueType="System.String" />
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="uid_company" Visible="False" ReadOnly="True" />
            
            <dx:GridViewDataComboBoxColumn FieldName="uid_product" Caption="Producto">
                <PropertiesComboBox DataSourceID="dsProducto" TextField="Producto" ValueField="uid_product" ValueType="System.String" />
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="uid_product" Visible="False" ReadOnly="True" />
        </Columns>
        <Settings ShowGroupPanel="False" />
        
    </dx:ASPxGridView>
</asp:Content>
