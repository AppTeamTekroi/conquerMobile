class URLConst {
 //  static const baseURL = "https://c360.zone/demo/vconquer/api/";
 //  static const baseURL = "http://127.0.0.1:8000/api/";
  // static const baseURL = "https://vconquer.c360.zone/vconquer_test/api/";

 // static const baseURL = "http://10.0.2.2:8000/api/";
 // php artisan serve --host=0.0.0.0 --port=8000
  static const baseURL = "https://vconquer.c360.zone/vconquer_test/api/";

  static const loginURL = "mobile-login";

   // static const dashboard = "mobile-login";


   //static const customers = "get-customers?draw=1&length=10&start=0";
  static const customers = "getAllCustomers";
  static const customersInfo = "get-customer-info/";
  static const storeCustomer = "store-new-customer";

  static const products = "get-items";
  static const products_quat = "get-cust-items-price/";

  //quotation

  static const addTocart = "quotation-cart";
  //static const cartUpdate = "v1/cart-update/";
  static const quo_cartUpdate = 'quotation-cart-update';
  static const getuser_cart = "get-quotation-cart/";
  static const create_quatation = "create-quotation";

  static const quatations_list = "get-quotations";
  static const quatations_details = "quotation/";

//opportunity
  static const opp_cartUpdate = 'opportunity-cart-update';

  static const opportunity_addTocart = "opportunity-cart";
  static const getopp_cart = "get-opportunity-cart/";
  static const create_Opportunity = "create-opportunity";
 // static const create_Opportunity = "c";

  static const Opportunity_list = "get-opportunities";
  static const Opportunity_details = "opportunity/";

//order
  static const order_cartUpdate = 'order-cart-update';

  static const order_addTocart = "order-cart";
  static const getorder_cart = "get-order-cart/";
  static const create_order = "create-order";

  static const order_list = "get-orders";
  //?draw=1&length=10&start=0&branch_count=&status=&search_quotation
  static const order_details = "order/";

  //covert opp-quot


  static const convertOpp_Quatation = "opportunityTo-quotation/";
  static const getconvertcart = "copy-opportunity-cart/";
  static const getconvertaddTocart = "opportunity-convert-cart/";

//convert quot-order

  static const convertQuatation_Order = "quotationTo-order/";
  static const getorderconvertcart = "copy-order-cart/";
  static const getorderconvertaddTocart = "quotation-convert-cart/";

//master
  static const contact = "get-customer-contacts/";
  static const billing = "get-cust-bill-addresses/";
  static const shipping = "get-cust-ship-addresses/";
  static const payterm = "get-payment-terms";
  static const branch = "get-branches";
  static const categories = "get-categories";
  static const subCategories = "get-subcategories";
  static const salesEmpName = "sales-emps";
  static const countries = "countries";
  static const searchByGstin = "search-customer-by-gstin";

  static const warranty = "get-warranty";
  static const delivery = "get-delivery";
  static const validity = "get-validity";
  static const architect = "get-solutionArchitect";


  //Dashboard
  static const salesData = "get-mtd_otd_ytd";
  static const salesReport = "sap-sales-report-json";
  static const consolationReport = "sap-consolidate-report-json";





}

