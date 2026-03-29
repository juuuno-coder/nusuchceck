import { View, Text, Pressable, ScrollView } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useRouter } from "expo-router";
import { Ionicons } from "@expo/vector-icons";

// 메뉴 아이템 컴포넌트
function MenuItem({ icon, label, iconColor = "#6b7280" }: {
  icon: keyof typeof Ionicons.glyphMap;
  label: string;
  iconColor?: string;
}) {
  return (
    <Pressable className="flex-row items-center py-4" style={{ borderBottomWidth: 1, borderBottomColor: '#f3f4f6' }}>
      <View className="w-9 h-9 bg-gray-50 rounded-xl items-center justify-center mr-3">
        <Ionicons name={icon} size={20} color={iconColor} />
      </View>
      <Text className="text-body text-gray-900 flex-1">{label}</Text>
      <Ionicons name="chevron-forward" size={18} color="#d1d5db" />
    </Pressable>
  );
}

export default function ProfileScreen() {
  const router = useRouter();

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1 px-5" contentContainerStyle={{ paddingBottom: 40 }}>
        {/* 헤더 */}
        <View className="pt-4 pb-5">
          <Text className="text-2xl font-bold tracking-tight text-gray-900">마이페이지</Text>
        </View>

        {/* 로그인 유도 카드 */}
        <Pressable
          className="bg-white rounded-3xl p-5 mb-6 flex-row items-center"
          style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
          onPress={() => router.push("/(auth)/login")}
        >
          <View className="w-14 h-14 bg-primary/10 rounded-full items-center justify-center mr-4">
            <Ionicons name="person-outline" size={28} color="#3b82f6" />
          </View>
          <View className="flex-1">
            <Text className="text-heading-3 text-gray-900">로그인하세요</Text>
            <Text className="text-caption text-gray-400 mt-0.5">
              점검 내역과 전문가 상담을 관리할 수 있어요
            </Text>
          </View>
          <Ionicons name="chevron-forward" size={20} color="#d1d5db" />
        </Pressable>

        {/* 메뉴 리스트 */}
        <View className="mb-4">
          <Text className="text-[11px] uppercase tracking-[0.15em] font-medium text-gray-400 mb-2 ml-1">내 서비스</Text>
          <View
            className="bg-white rounded-3xl p-5"
            style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
          >
            <MenuItem icon="document-text-outline" label="점검 내역" iconColor="#3b82f6" />
            <MenuItem icon="card-outline" label="결제 내역" iconColor="#22c55e" />
            <MenuItem icon="chatbubble-outline" label="상담 내역" iconColor="#8b5cf6" />
          </View>
        </View>

        <View>
          <Text className="text-[11px] uppercase tracking-[0.15em] font-medium text-gray-400 mb-2 ml-1">설정</Text>
          <View
            className="bg-white rounded-3xl p-5"
            style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
          >
            <MenuItem icon="notifications-outline" label="알림 설정" />
            <MenuItem icon="help-circle-outline" label="고객센터" />
            <MenuItem icon="information-circle-outline" label="앱 정보" />
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
