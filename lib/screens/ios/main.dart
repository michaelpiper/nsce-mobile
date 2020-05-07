import 'package:NSCE/screens/ios/invoice.dart';
import 'package:NSCE/screens/ios/schedule_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NSCE/utils/colors.dart';
// import screen here
import 'home.dart';
import 'profile.dart';
import 'splash.dart';
import 'auth.dart';
import 'settings.dart';
import 'addfund.dart';
import 'transaction.dart';
import 'product.dart';
import 'search.dart';
import 'cart.dart';
import 'quarry.dart';
import 'quarries.dart';
import 'dispatch.dart';
import 'order.dart';
import 'orders.dart';
import 'confirm_order.dart';
import 'type.dart';
import 'schedule.dart';
import 'confirm_schedule.dart';
import 'favorite.dart';
import 'checkout.dart';
import 'shipping.dart';
import 'save_and_pay.dart';
// import services here
import '../../services/auth.dart';
import 'driver/dispatch.dart';
import 'driver/home.dart';
import 'driver/profile.dart';
// import color
import '../../utils/colors.dart';
import './chat.dart';

buildAndroid(context){

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: primaryColor,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: primaryColor,
  )) ;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  final navigatorKey = GlobalKey<NavigatorState>();
  return MaterialApp(
    title: 'NSCE',
    navigatorKey: navigatorKey,
    theme: ThemeData(
      // This is the theme of your application.
      primarySwatch: primarySwatch,
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(color: primaryColor,brightness: Brightness.light,iconTheme: IconThemeData(color: primaryTextColor)),
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme,
      ),
    ),
    home: FutureBuilder(
      future: Provider.of<AuthService>(context).getUserForLaunch(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          if(snapshot.hasData){
            if(snapshot.data['Role']!=null && snapshot.data['Role']['name']=="Driver"){
              return DriverHomePage();
            }else{
              return HomePage();
            }
          }else{
            return AuthPage();
          }
        }else{
          return SplashPage();
        }
      },
    ),
    onGenerateRoute: (settings){
      List data=settings.name.split('/');
      // print(data);
      if(data[1]=='home' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return  HomePage(currentIndex :int.parse(data[2]));
        });
      }
      else if(data[1]=='transaction' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return  TransactionPage(trnId:int.parse(data[2]));
        });
      }
      else  if(data[1]=='product' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return ProductPage(id:int.parse(data[2]));
        });
      }
      else if(data[1]=='quarry' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return QuarryPage(index:int.parse(data[2]));
        });
      }
      else if(data[1]=='type' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return TypePage(index:int.parse(data[2]));
        });
      }
      else if(data[1]=='shipping' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return ShippingPage(index:int.parse(data[2]));
        });
      }
      else if(data[1]=='order' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return OrderPage(index:int.parse(data[2]));
        });
      }
      else if(data[1]=='dispatch' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return DispatchPage(index:int.parse(data[2]));
        });
      }
      else if(data[1]=='driver-dispatch' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return DriverDispatchPage(index:int.parse(data[2]));
        });
      }else{
        return MaterialPageRoute(builder: (context){
          return HomePage();
        });
      }

    },
    routes: <String, WidgetBuilder> {
      '/home': (BuildContext context) => HomePage(),
      '/profile': (BuildContext context) => ProfilePage(),
      '/auth' : (BuildContext context) => AuthPage(),
      '/splash' : (BuildContext context) => SplashPage(),
      '/settings':(BuildContext context) => SettingsPage(),
      '/addfunds':(BuildContext context) => AddFundsPage(),
      '/search':(BuildContext context) =>SearchPage(),
      '/cart':(BuildContext context) => CartPage(),
      '/orders':(BuildContext context) => OrdersPage(),
      '/quarries':(BuildContext context) => QuarriesPage(),
      '/type':(BuildContext context) =>TypePage(),
      '/favorite':(BuildContext context) =>FavoritePage(),
      '/checkout':(BuildContext context) =>CheckoutPage(),
      '/confirm_schedule':(BuildContext context) =>ConfirmSchedulePage(),
      '/confirm_order':(BuildContext context) =>ConfirmOrderPage(),
      '/save_and_pay':(BuildContext context) =>SaveAndPay(),
      '/schedule':   (BuildContext context) =>SchedulePage(),
      '/driver-profile':(BuildContext context) =>DriverProfilePage(),
      '/driver-home':(BuildContext context) =>DriverHomePage(),
      '/chat':(BuildContext context) =>ChatPage(),
      '/invoices': (BuildContext context) => InvoicesPage(),
      '/schedule-list':(BuildContext context) =>ScheduleListPage()
    },
  );
}




