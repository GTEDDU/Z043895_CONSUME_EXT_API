CLASS zcl_products_fetch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider.
    TYPES    lt_business_data TYPE TABLE OF zsc_ext_api_call=>tys_alphabetical_list_of_produ.
    TYPES    lt_range_PRODUCT_ID TYPE RANGE OF int4.

    METHODS get_products
      IMPORTING it_filter_cond   TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
                top              TYPE i OPTIONAL
                skip             TYPE i OPTIONAL
      EXPORTING
                et_business_data TYPE  lt_business_data
      RAISING
                /iwbep/cx_cp_remote
                /iwbep/cx_gateway
                cx_web_http_client_error
                cx_http_dest_provider_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_products_fetch IMPLEMENTATION.

**********************************************************************
  METHOD if_oo_adt_classrun~main.
    DATA: lt_business_data TYPE TABLE OF zsc_ext_api_call=>tys_alphabetical_list_of_produ.
    DATA: lt_filter_conditions TYPE if_rap_query_filter=>tt_name_range_pairs.
    DATA: Lt_range_table TYPE if_rap_query_filter=>tt_range_option.


    Lt_range_table =  VALUE #( ( sign = 'I' option = 'EQ' low  = '4' ) ).
    lt_filter_conditions = VALUE #( ( name = 'ProductID' range = Lt_range_table ) ).
    TRY.

        me->get_products(
          EXPORTING
            it_filter_cond   =  lt_filter_conditions
            top              = 50
            skip             = 1
          IMPORTING
            et_business_data = lt_business_data
        ).
        out->write( lt_business_data ).
      CATCH cx_root INTO DATA(ls_root).
    ENDTRY.
  ENDMETHOD.
  METHOD get_products.

    DATA:   lt_business_data TYPE TABLE OF zsc_ext_api_call=>tys_alphabetical_list_of_produ.

*  Create destination
    DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://services.odata.org'  ).
*  Create HTTP client from Destination
    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).

    DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
             EXPORTING
                is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                    proxy_model_id      = 'ZSC_EXT_API_CALL'
                                                    proxy_model_version = '0001' )
               io_http_client             = lo_http_client
               iv_relative_service_root   = '/V4/Northwind/Northwind.svc/' ).
    ASSERT lo_client_proxy IS BOUND.

*   Initialize Request
    " Navigate to the resource and create a request for the create operation
    DATA(lo_entity_list_resource) = lo_client_proxy->create_resource_for_entity_set( iv_entity_set_name = 'PRODUCTS' ). "
*   Data Read request
    DATA(lo_read_list_request) = lo_entity_list_resource->create_request_for_read( ).
*   execte
    DATA(lo_read_list_response) = lo_read_list_request->execute( ).
*   Get Data
    lo_read_list_response->get_business_data(
      IMPORTING
       et_business_data = et_business_data
    ).
*      CATCH /iwbep/cx_gateway.

  ENDMETHOD.
**********************************************************************
  METHOD if_rap_query_provider~select.

    DATA: lt_business_data TYPE TABLE OF zsc_ext_api_call=>tys_alphabetical_list_of_produ.
*   TOP
    DATA(lv_top) = io_request->get_paging( )->get_page_size( ).
*   skip
    DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
*   Sort
    DATA(lt_SORT) = io_request->get_sort_elements( ).
*   Requested Elements
    DATA(lt_requested) = io_request->get_requested_elements( ).
*   Filters
    TRY.
        DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(ex_ranges).
    ENDTRY.
    TRY.
        get_products(
          EXPORTING
            it_filter_cond   =  lt_filters
            top              =  CONV i( lv_top )
            skip             =  CONV i( lv_skip )
          IMPORTING
            et_business_data = lt_business_data
        ).
*    CATCH /iwbep/cx_cp_remote.
*    CATCH /iwbep/cx_gateway.
*    CATCH cx_web_http_client_error.
*    CATCH cx_http_dest_provider_error.
      CATCH cx_root INTO DATA(ls_root) .
    ENDTRY.
*   Apply Sort
    DATA it_sort_data TYPE abap_sortorder_tab.
    IF lt_SORT IS NOT INITIAL.
      it_sort_data  = VALUE #( FOR ls_sort IN lt_SORT ( name = ls_sort-element_name
                                                        descending =  ls_sort-descending
                                                           ) ).
      SORT lt_business_data BY (it_sort_data).
      FREE: lt_sort,
            it_sort_data.
    ENDIF.

    io_response->set_total_number_of_records( lines( lt_business_data )  ).

*     Apply filters the output data
    DATA(ls_filter) = io_request->get_filter( )->get_as_sql_string( ).
    IF ls_filter IS NOT INITIAL.
      DATA(lt_business_data_TMP) =  lt_business_data.
      FREE lt_business_data.
      lt_business_data = VALUE #( FOR ls_temp IN lt_business_data_TMP WHERE (ls_filter) ( ls_temp )  ) .
      FREE lt_business_data_TMP.
    ENDIF.
*   Expression filters
    DATA(ls_expression) = io_request->get_search_expression( ).

    io_response->set_data( it_data = lt_business_data ).
*    CATCH cx_rap_query_response_set_twic.
*    CATCH cx_rap_query_response_set_twic.
  ENDMETHOD.

ENDCLASS.
