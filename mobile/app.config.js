export default {
  expo: {
    name: '누수체크',
    slug: 'nusucheck',
    scheme: 'nusucheck',
    version: '1.0.0',
    orientation: 'portrait',
    icon: './assets/icon.png',
    userInterfaceStyle: 'light',
    newArchEnabled: false,
    splash: {
      image: './assets/splash-icon.png',
      resizeMode: 'contain',
      backgroundColor: '#FFFFFF',
    },
    ios: {
      supportsTablet: true,
      bundleIdentifier: 'com.vibers.nusucheck',
    },
    android: {
      adaptiveIcon: {
        foregroundImage: './assets/adaptive-icon.png',
        backgroundColor: '#FFFFFF',
      },
      package: 'com.vibers.nusucheck',
    },
    plugins: [
      'expo-router',
      'expo-font',
      'expo-secure-store',
      'expo-asset',
    ],
    extra: {
      apiUrl: 'https://nusucheck.com',
      eas: {
        projectId: 'EAS_INIT으로_생성',
      },
    },
  },
};
