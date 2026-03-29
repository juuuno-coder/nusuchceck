import { View, Text, Pressable, ScrollView } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";

export default function InspectionScreen() {
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1 px-5" contentContainerStyle={{ paddingBottom: 40 }}>
        {/* 헤더 */}
        <View className="pt-4 pb-5">
          <Text className="text-2xl font-bold tracking-tight text-gray-900">점검 신청</Text>
          <Text className="text-body text-gray-400 mt-1">
            누수가 의심되는 곳을 점검해보세요
          </Text>
        </View>

        {/* AI 점검 카드 */}
        <Pressable
          className="bg-primary rounded-3xl p-5 mb-4 flex-row items-center"
          style={{ shadowColor: '#3b82f6', shadowOpacity: 0.2, shadowRadius: 12, shadowOffset: { width: 0, height: 4 }, elevation: 4 }}
        >
          <View className="w-14 h-14 bg-white/20 rounded-2xl items-center justify-center mr-4">
            <Ionicons name="flash" size={28} color="#ffffff" />
          </View>
          <View className="flex-1">
            <Text className="text-white text-heading-3">AI 점검</Text>
            <Text className="text-white/80 text-body mt-0.5">사진으로 빠르게 분석</Text>
          </View>
          <Ionicons name="chevron-forward" size={20} color="rgba(255,255,255,0.7)" />
        </Pressable>

        {/* 전문가 점검 카드 */}
        <Pressable
          className="bg-white rounded-3xl p-5 mb-4 flex-row items-center"
          style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
        >
          <View className="w-14 h-14 bg-primary/10 rounded-2xl items-center justify-center mr-4">
            <Ionicons name="construct-outline" size={28} color="#3b82f6" />
          </View>
          <View className="flex-1">
            <Text className="text-gray-900 text-heading-3">전문가 점검</Text>
            <Text className="text-gray-400 text-body mt-0.5">전문가가 직접 방문 점검</Text>
          </View>
          <Ionicons name="chevron-forward" size={20} color="#d1d5db" />
        </Pressable>

        {/* 긴급 점검 카드 */}
        <Pressable
          className="bg-white rounded-3xl p-5 mb-4 flex-row items-center"
          style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
        >
          <View className="w-14 h-14 bg-red-50 rounded-2xl items-center justify-center mr-4">
            <Ionicons name="alert-circle-outline" size={28} color="#ef4444" />
          </View>
          <View className="flex-1">
            <Text className="text-gray-900 text-heading-3">긴급 점검</Text>
            <Text className="text-gray-400 text-body mt-0.5">24시간 긴급 출동 서비스</Text>
          </View>
          <Ionicons name="chevron-forward" size={20} color="#d1d5db" />
        </Pressable>

        {/* 안내 */}
        <View className="bg-primary/5 rounded-3xl p-5 items-center mt-2">
          <Ionicons name="information-circle-outline" size={22} color="#3b82f6" />
          <Text className="text-body text-gray-500 mt-2 text-center">
            점검 유형을 선택하면{"\n"}상세 신청 폼이 열립니다
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
