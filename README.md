# DairyTrack - Dairy Delivery Management App

A comprehensive Flutter application for managing dairy delivery operations, built with modern UI/UX principles and scalable architecture.

## 🚀 Features

### 🔐 Authentication & Role Management
- **Login/Signup** with email/phone authentication
- **Role-based access** (Admin/Customer)
- **Secure authentication** flow with proper state management

### 👨‍💼 Admin Dashboard
- **Overview Cards**: Total customers, pending payments, today's deliveries, monthly revenue
- **Customer Management**: 
  - List, search, and filter 2000+ customers
  - Add/edit customer details
  - Credit limit and balance tracking
- **Delivery Tracking**: 
  - Record daily deliveries
  - Mark deliveries as completed
  - Track delivery status and personnel
- **Billing Management**:
  - Generate monthly bills
  - Track payments and outstanding amounts
  - Payment method tracking (Cash, UPI, Bank Transfer, Cheque)
- **Product Catalog**: 
  - Manage dairy products (Milk, Curd, Butter, Cheese, etc.)
  - Stock quantity tracking
  - Price management
- **Reports & Analytics**: 
  - Sales reports
  - Credit outstanding reports
  - Payment collection analytics

### 👤 Customer Dashboard
- **Profile & Account Summary**
- **Daily Delivery Summary**: Products delivered, quantities, dates
- **Monthly Bill Summary**: Running credit total and due dates
- **Payment History**: Track all transactions
- **Reminder Notifications**: Payment due alerts

## 🎨 Design & UI

### Theme
- **Dairy Shop Friendly Colors**: Soft cream, light green, pastel blue
- **Material 3 Design**: Modern, clean interface
- **Responsive Layout**: Works on all screen sizes
- **Smooth Animations**: Enhanced user experience

### Navigation
- **Bottom Navigation**: Easy access to main features
- **Role-based Navigation**: Different flows for Admin/Customer
- **Intuitive Icons**: Clear visual indicators

## 🏗️ Architecture

### Tech Stack
- **Flutter 3.x** with Dart
- **Provider** for state management
- **Material 3** widgets
- **Google Fonts** for typography
- **FL Chart** for analytics

### Project Structure
```
lib/
├── constants/          # App constants, colors, strings, theme
├── models/            # Data models (User, Customer, Delivery, Bill, Product)
├── providers/         # State management (Auth, Customer, Delivery, Billing, Product)
├── screens/           # UI screens
│   ├── auth/         # Authentication screens
│   ├── admin/        # Admin dashboard and management screens
│   └── customer/     # Customer dashboard and screens
├── utils/            # Utility functions and mock data
└── widgets/          # Reusable UI components
```

### State Management
- **Provider Pattern**: Clean separation of concerns
- **Reactive UI**: Automatic updates when data changes
- **Error Handling**: Proper error states and user feedback

## 📊 Mock Data

The app includes comprehensive mock data for testing:
- **2000+ Customers** with realistic data
- **500+ Deliveries** with various statuses
- **300+ Bills** with payment tracking
- **6+ Products** in the dairy catalog

## 🚀 Getting Started

### Prerequisites
- Flutter 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dairy_track
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Default Login Credentials

#### Admin Access
- **Email**: admin@dairytrack.com
- **Phone**: 9876543210
- **Password**: Any password (6+ characters)
- **Role**: Admin

#### Customer Access
- **Email**: customer@email.com
- **Phone**: Any valid phone number
- **Password**: Any password (6+ characters)
- **Role**: Customer

## 🔧 Configuration

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2          # State management
  google_fonts: ^6.2.1      # Typography
  fl_chart: ^0.68.0         # Charts and analytics
  intl: ^0.19.0             # Date formatting
  http: ^1.2.1              # API calls (future)
  shared_preferences: ^2.2.3 # Local storage
```

### Environment Setup
- Update `pubspec.yaml` with your app details
- Configure Firebase (optional) for production
- Set up API endpoints for backend integration

## 🔮 Future Enhancements

### Backend Integration
- **Firebase/Firestore**: Real-time database
- **REST API**: MySQL/PostgreSQL backend
- **Authentication**: Firebase Auth or custom JWT

### Advanced Features
- **Push Notifications**: Payment reminders, delivery updates
- **SMS Integration**: Automated reminders
- **GPS Tracking**: Delivery route optimization
- **Offline Support**: Work without internet
- **Multi-language**: Localization support

### Analytics & Reporting
- **Advanced Charts**: Revenue trends, customer analytics
- **Export Features**: PDF reports, Excel exports
- **Dashboard Widgets**: Customizable admin dashboard

## 📱 Screenshots

### Login Screen
- Role selection (Admin/Customer)
- Clean, modern authentication UI
- Dairy-themed color scheme

### Admin Dashboard
- Overview statistics cards
- Quick action buttons
- Bottom navigation for easy access

### Customer Management
- Search and filter functionality
- Customer statistics
- Detailed customer cards

### Customer Dashboard
- Delivery summary
- Bill overview
- Payment tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🎯 Roadmap

- [ ] Complete customer management CRUD operations
- [ ] Implement delivery tracking with real-time updates
- [ ] Add comprehensive billing and payment system
- [ ] Create detailed reports and analytics
- [ ] Add push notifications
- [ ] Implement offline support
- [ ] Add multi-language support
- [ ] Create admin settings and configuration

---

**DairyTrack** - Making dairy delivery management simple and efficient! 🥛