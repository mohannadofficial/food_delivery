const String APP_URL = 'http://mvs.bslmeiyu.com';
const String UPLOAD = '/uploads/';
const String POPULAR = '/api/v1/products/popular';
const String RECOMMENDED = '/api/v1/products/recommended';
const String REGISTER = '/api/v1/auth/register';
const String LOGIN = '/api/v1/auth/login';
const String PROFILE = '/api/v1/customer/info';
const String GETOCODE_URI = '/api/v1/config/geocode-api';
const String ADD_USER_ADDRESS = '/api/v1/customer/address/add';
const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
const String PLACE_DETAILS_URI='/api/v1/customer/order/place';
const String LIST_DETAILS_URI = '/api/v1/customer/order/list';
const String DETAILS_BY_ORDER_URI = '/api/v1/customer/order/details';



// Token Login and Register
var token = '';
bool? firstTimeApp;

const String ON_BOARDING = 'on-boarding';
const String CART_LIST = 'cart-list';
const String CART_HISTORY = 'cart-history';
const String USER_ADDRESS = 'user-address';