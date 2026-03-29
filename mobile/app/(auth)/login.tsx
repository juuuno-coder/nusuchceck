import { View, Text, TextInput, Pressable } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { Ionicons } from "@expo/vector-icons";

export default function LoginScreen() {
  const router = useRouter();

  return (
    <SafeAreaView className="flex-1 bg-white">
      <View className="flex-1 px-5">
        {/* 닫기 버튼 */}
        <Pressable className="pt-4 pb-2 w-10" onPress={() => router.back()}>
          <Ionicons name="close" size={28} color="#374151" />
        </Pressable>

        {/* 로고 / 타이틀 */}
        <View className="mt-10 mb-10">
          <Text className="text-2xl font-bold tracking-tight text-primary mb-1">누수체크</Text>
          <Text className="text-body text-gray-400 mt-1">
            로그인하고 점검 서비스를 이용하세요
          </Text>
        </View>

        {/* 이메일 입력 */}
        <View className="mb-4">
          <Text className="text-[11px] uppercase tracking-[0.15em] font-medium text-gray-400 mb-2 ml-1">이메일</Text>
          <TextInput
            className="bg-gray-50 rounded-2xl px-4 py-4 text-body text-gray-900"
            style={{ borderWidth: 1, borderColor: '#f3f4f6' }}
            placeholder="이메일을 입력하세요"
            placeholderTextColor="#9ca3af"
            keyboardType="email-address"
            autoCapitalize="none"
          />
        </View>

        {/* 비밀번호 입력 */}
        <View className="mb-8">
          <Text className="text-[11px] uppercase tracking-[0.15em] font-medium text-gray-400 mb-2 ml-1">비밀번호</Text>
          <TextInput
            className="bg-gray-50 rounded-2xl px-4 py-4 text-body text-gray-900"
            style={{ borderWidth: 1, borderColor: '#f3f4f6' }}
            placeholder="비밀번호를 입력하세요"
            placeholderTextColor="#9ca3af"
            secureTextEntry
          />
        </View>

        {/* 로그인 버튼 */}
        <Pressable className="bg-primary rounded-full py-3.5 items-center mb-4">
          <Text className="text-white font-semibold text-heading-3">로그인</Text>
        </Pressable>

        {/* 회원가입 링크 */}
        <View className="flex-row justify-center mt-2">
          <Text className="text-body text-gray-400">계정이 없으신가요? </Text>
          <Pressable>
            <Text className="text-body text-primary font-semibold">회원가입</Text>
          </Pressable>
        </View>
      </View>
    </SafeAreaView>
  );
}
