<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="ClientsDir.aspx.cs" Inherits="dir_clients.ClientsDir" %>

<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Content/GridView.css") %>' />
    <script type="text/javascript" src='<%# ResolveUrl("~/Content/GridView.js") %>'></script>
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
                    <h1>Directorio</h1>
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
    <script type="text/javascript">
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
            //loadingpanel.Hide();
        }
    </script>
    <dx:ASPxCallback ID="cbpage" ClientInstanceName="cbpage" runat="server" OnCallback="cbpage_Callback">
        <ClientSideEvents CallbackComplete="cbpageCallbackComplete" />
    </dx:ASPxCallback>
    <dx:EntityServerModeDataSource ID="dsClients" runat="server" EnableInsert="true" EnableUpdate="true" EnableDelete="True"  OnSelecting="dsClients_Selecting" OnInserting="dsClients_Inserting" OnUpdating="dsClients_Updating" OnDeleting="dsClients_Deleting" ContextTypeName="ClientsDataModel" TableName="vclients" />
    <dx:ASPxGridView runat="server" ID="GridView" ClientInstanceName="gridView" 
        KeyFieldName="uid_client" KeyboardSupport="true" EnablePagingGestures="False" Width="100%"
        DataSourceID="dsClients"
        OnCustomCallback="GridView_CustomCallback"
        OnRowUpdating="GridView_RowUpdating" OnRowInserting="GridView_RowInserting" OnRowDeleting="GridView_RowDeleting" AutoGenerateColumns="False"
        OnCustomErrorText="GridView_CustomErrorText">
        
        <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" /> 

        <SettingsResizing ColumnResizeMode="Control" />
        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
        <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
        <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
        <Settings VerticalScrollBarMode="Visible" VerticalScrollableHeight="730" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true"/>
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
                        <dx:GridViewColumnLayoutItem Caption="Direccion" ColSpan="1" ColumnName="direccion">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Telefono" ColSpan="1" ColumnName="telefono">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Celular" ColSpan="1" ColumnName="celular">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Email" ColSpan="1" ColumnName="email">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Email 2" ColSpan="1" ColumnName="email2">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Relacionado" ColSpan="1" ColumnName="relacionado">
                        </dx:GridViewColumnLayoutItem>
                        <dx:GridViewColumnLayoutItem Caption="Archivero" ColSpan="1" ColumnName="archivero">
                        </dx:GridViewColumnLayoutItem>
                        <dx:EditModeCommandLayoutItem ColSpan="2" HorizontalAlign="Right">
                        </dx:EditModeCommandLayoutItem>
                    </Items>
                </dx:GridViewLayoutGroup>
            </Items>
        </EditFormLayoutProperties>
        <Columns>
            <%--<dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="45"></dx:GridViewCommandColumn>--%>
            <dx:GridViewDataTextColumn FieldName="uid_client" ShowInCustomizationForm="True" Visible="False" VisibleIndex="1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataHyperLinkColumn FieldName="nombre" Name="Nombre" Caption="Nombre" ShowInCustomizationForm="True" VisibleIndex="2" Width="300px">
                <PropertiesHyperLinkEdit EnableClientSideAPI="true" NavigateUrlFormatString="javascript:edicion()"></PropertiesHyperLinkEdit>
            </dx:GridViewDataHyperLinkColumn>
            <dx:GridViewDataTextColumn FieldName="direccion" Name="direccion" Caption="Dirección" ShowInCustomizationForm="True" VisibleIndex="3" Width="450px">
            </dx:GridViewDataTextColumn> 
            <dx:GridViewDataTextColumn FieldName="telefono" Name="telefono" Caption="Teléfono" ShowInCustomizationForm="True" VisibleIndex="4" Width="100px">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="celular" Name="celular" Caption="Celular" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="email" Name="email" Caption="Email" ShowInCustomizationForm="True" VisibleIndex="6" Width="210px">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="email2" Name="email2" Caption="Email 2" ShowInCustomizationForm="True" VisibleIndex="7" Width="210px">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="canpol" Name="canpol" Caption="# Plz." ShowInCustomizationForm="True" VisibleIndex="8" Width="100px">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataMemoColumn FieldName="relacionado" Name="relacionado" Caption="Relacionado" VisibleIndex="9" Width="300px">
            </dx:GridViewDataMemoColumn>
            <dx:GridViewDataMemoColumn FieldName="archivero" Name="archivero" Caption="Archivero" VisibleIndex="10" Width="100px">
            </dx:GridViewDataMemoColumn>
        </Columns>

    </dx:ASPxGridView>
</asp:Content>
