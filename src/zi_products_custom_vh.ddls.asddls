@EndUserText.label: 'Custom entity for Product Display'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PRODUCTS_FETCH'
@Metadata.allowExtensions: true
@Search.searchable: true
@UI: {
  headerInfo: {
                typeName: 'Product Details',
                typeNamePlural: 'Products',
              description: {
                            type: #STANDARD,
                            value: 'product_id'
                            },
                    title: {
                            value: 'product_name'
                            }
            }
}

define root custom entity ZI_PRODUCTS_CUSTOM_VH

{

      @UI.facet         : [{

          purpose       : #STANDARD,
          position      : 10 ,
          importance    : #HIGH,
          label         : 'Details',
          type          :#IDENTIFICATION_REFERENCE
      }]
      @UI.lineItem      : [{ position: 10, label: 'Product Id' }]
      @UI.identification: [{ position: 10, label: 'Product Id' }]
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @UI.selectionField: [{ position: 10  }]
      //       @Consumption.filter.mandatory: true
            @Consumption.valueHelpDefinition: [ { entity:  { name: '/DMO/I_Travel_Status_VH',
                                                         element: 'TravelStatus' } }]

  key product_id        : abap.int4;
      @UI.lineItem      : [{ position: 20, label: 'Product Name' }]
      @UI.identification: [{ position: 20, label: 'Product Name' }]
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      product_name      : abap.char( 100 );
      @UI.lineItem      : [{ position: 30, label: 'Supplier Id' }]
      @UI.identification: [{ position: 30, label: 'Supplier Id' }]
      supplier_id       : abap.int4;
      @UI.lineItem      : [{ position: 40, label: 'Category Id' }]
      @UI.identification: [{ position: 40, label: 'Category Id' }]
      category_id       : abap.int4;
      @UI.lineItem      : [{ position: 50, label: 'Quantity Per Unit' }]
      @UI.identification: [{ position: 50, label: 'Quantity Per Unit' }]
      quantity_per_unit : abap.char( 100 );
      @UI.lineItem      : [{ position: 60, label: 'Unit Price' }]
      @UI.identification: [{ position: 60, label: 'Unit Price' }]
      unit_price        : abap.dec( 16, 2 );
      @UI.lineItem      : [{ position: 70, label: 'Unit in Stock' }]
      @UI.identification: [{ position: 70, label: 'Unit in Stock' }]
      units_in_stock    : abap.int2;
      @UI.lineItem      : [{ position: 80, label: 'Unit in Order' }]
      @UI.identification: [{ position: 80, label: 'Unit in Order' }]
      units_on_order    : abap.int2;
      @UI.lineItem      : [{ position: 90, label: 'Reorder Level' }]
      @UI.identification: [{ position: 90, label: 'Reorder Level' }]
      reorder_level     : abap.int2;
      @UI.lineItem      : [{ position: 100, label: 'Discontinued' }]
      @UI.identification: [{ position: 100, label: 'Discontinued' }]
      discontinued      : abap.char( 1 );
      @UI.lineItem      : [{ position: 110, label: 'Category Name' }]
      @UI.identification: [{ position: 110, label: 'Category Name' }]
      category_name     : abap.char( 100 );
}
