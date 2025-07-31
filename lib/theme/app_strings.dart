/// SeoulOppa 앱의 문자열 시스템
/// Figma Variables의 'string' 그룹에서 정의된 텍스트를 Flutter에서 사용 가능한 형태로 변환
/// 
/// 사용법:
/// ```dart
/// Text(AppStrings.appName)
/// Text(AppStrings.navigationHome)
/// ```
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // App Information
  static const String appName = 'SeoulOppa';
  static const String appVersion = '1.0.0';
  static const String appDescription = '서울에서 만나는 새로운 인연';

  // Navigation & Tabs
  static const String navigationHome = '홈';
  static const String navigationMeeting = '만남';
  static const String navigationNearby = '근처';
  static const String navigationTravel = '여행';
  static const String navigationCommunity = '커뮤니티';
  static const String navigationProfile = '프로필';
  static const String navigationSettings = '설정';

  // Common Actions
  static const String actionLogin = '로그인';
  static const String actionLogout = '로그아웃';
  static const String actionSignUp = '회원가입';
  static const String actionSave = '저장';
  static const String actionCancel = '취소';
  static const String actionDelete = '삭제';
  static const String actionEdit = '수정';
  static const String actionConfirm = '확인';
  static const String actionNext = '다음';
  static const String actionPrevious = '이전';
  static const String actionComplete = '완료';
  static const String actionSkip = '건너뛰기';
  static const String actionRetry = '다시 시도';
  static const String actionRefresh = '새로고침';
  static const String actionShare = '공유';
  static const String actionReport = '신고';
  static const String actionBlock = '차단';
  static const String actionLike = '좋아요';
  static const String actionComment = '댓글';
  static const String actionSend = '전송';

  // Authentication
  static const String authWelcome = '환영합니다!';
  static const String authLoginTitle = '로그인';
  static const String authSignUpTitle = '회원가입';
  static const String authForgotPassword = '비밀번호를 잊으셨나요?';
  static const String authEmailPlaceholder = '이메일을 입력하세요';
  static const String authPasswordPlaceholder = '비밀번호를 입력하세요';
  static const String authConfirmPasswordPlaceholder = '비밀번호를 다시 입력하세요';
  static const String authNamePlaceholder = '이름을 입력하세요';
  static const String authLoginWithGoogle = 'Google로 로그인';
  static const String authLoginWithApple = 'Apple로 로그인';
  static const String authLoginWithKakao = 'Kakao로 로그인';
  static const String authTermsAndConditions = '이용약관';
  static const String authPrivacyPolicy = '개인정보처리방침';
  static const String authAgreeToTerms = '이용약관에 동의합니다';

  // Profile
  static const String profileTitle = '프로필';
  static const String profileEdit = '프로필 수정';
  static const String profileName = '이름';
  static const String profileAge = '나이';
  static const String profileGender = '성별';
  static const String profileLocation = '지역';
  static const String profileBio = '자기소개';
  static const String profileInterests = '관심사';
  static const String profilePhotos = '사진';
  static const String profileSettings = '프로필 설정';
  static const String profileMale = '남자';
  static const String profileFemale = '여자';
  static const String profileOther = '기타';

  // Meetings & Dating
  static const String meetingTitle = '만남';
  static const String meetingSerious = '진지한연애';
  static const String meetingCasual = '가벼운만남';
  static const String meetingFriends = '친구만들기';
  static const String meetingActivity = '액티비티';
  static const String meetingRequest = '만남 신청';
  static const String meetingAccept = '만남 수락';
  static const String meetingDecline = '만남 거절';
  static const String meetingPending = '대기중';
  static const String meetingMatched = '매칭됨';
  static const String meetingChat = '채팅';
  static const String meetingLocation = '만남 장소';
  static const String meetingTime = '만남 시간';

  // Travel
  static const String travelTitle = '여행';
  static const String travelPlan = '여행 계획';
  static const String travelDestination = '여행지';
  static const String travelDate = '여행 날짜';
  static const String travelBudget = '여행 예산';
  static const String travelCompanion = '여행 동행';
  static const String travelItinerary = '여행 일정';
  static const String travelRecommendation = '추천 여행지';
  static const String travelExperience = '여행 후기';
  static const String travelPhoto = '여행 사진';
  static const String travelSeoul = '서울';
  static const String travelBusan = '부산';
  static const String travelJeju = '제주';

  // Places in Seoul
  static const String placeNamsan = '남산타워';
  static const String placeMyeongdong = '명동';
  static const String placeGangnam = '강남';
  static const String placeHongdae = '홍대';
  static const String placeItaewon = '이태원';
  static const String placeBukchon = '북촌한옥마을';
  static const String placeInsadong = '인사동';
  static const String placeDongdaemun = '동대문';
  static const String placeHanriver = '한강';

  // Community
  static const String communityTitle = '커뮤니티';
  static const String communityPost = '게시글';
  static const String communityComment = '댓글';
  static const String communityLike = '좋아요';
  static const String communityShare = '공유';
  static const String communityFollow = '팔로우';
  static const String communityUnfollow = '언팔로우';
  static const String communityFollowers = '팔로워';
  static const String communityFollowing = '팔로잉';
  static const String communityTrending = '인기';
  static const String communityRecent = '최신';
  static const String communityMyPosts = '내 게시글';

  // Notifications
  static const String notificationTitle = '알림';
  static const String notificationNewMessage = '새 메시지';
  static const String notificationNewMatch = '새 매칭';
  static const String notificationLiked = '좋아요를 받았습니다';
  static const String notificationCommented = '댓글이 달렸습니다';
  static const String notificationFollowed = '팔로우했습니다';
  static const String notificationSettings = '알림 설정';
  static const String notificationPush = '푸시 알림';
  static const String notificationEmail = '이메일 알림';
  static const String notificationSMS = 'SMS 알림';

  // Settings
  static const String settingsTitle = '설정';
  static const String settingsAccount = '계정';
  static const String settingsPrivacy = '개인정보';
  static const String settingsSecurity = '보안';
  static const String settingsNotifications = '알림';
  static const String settingsLanguage = '언어';
  static const String settingsTheme = '테마';
  static const String settingsHelp = '도움말';
  static const String settingsAbout = '앱 정보';
  static const String settingsTerms = '이용약관';
  static const String settingsPrivacyPolicy = '개인정보처리방침';
  static const String settingsContactUs = '문의하기';
  static const String settingsVersion = '버전';
  static const String settingsLogout = '로그아웃';
  static const String settingsDeleteAccount = '계정 삭제';

  // Error Messages
  static const String errorGeneral = '오류가 발생했습니다';
  static const String errorNetwork = '네트워크 연결을 확인해주세요';
  static const String errorAuth = '인증에 실패했습니다';
  static const String errorInvalidEmail = '올바른 이메일을 입력해주세요';
  static const String errorInvalidPassword = '비밀번호는 최소 6자 이상이어야 합니다';
  static const String errorPasswordMismatch = '비밀번호가 일치하지 않습니다';
  static const String errorRequired = '필수 항목입니다';
  static const String errorServerError = '서버 오류가 발생했습니다';
  static const String errorTimeout = '요청 시간이 초과되었습니다';
  static const String errorNotFound = '찾을 수 없습니다';
  static const String errorPermissionDenied = '권한이 없습니다';

  // Success Messages
  static const String successSaved = '저장되었습니다';
  static const String successUpdated = '업데이트되었습니다';
  static const String successDeleted = '삭제되었습니다';
  static const String successSent = '전송되었습니다';
  static const String successLogin = '로그인되었습니다';
  static const String successLogout = '로그아웃되었습니다';
  static const String successSignUp = '회원가입이 완료되었습니다';

  // Loading & Status
  static const String loading = '로딩 중...';
  static const String loadingMore = '더 불러오는 중...';
  static const String noData = '데이터가 없습니다';
  static const String noResults = '검색 결과가 없습니다';
  static const String emptyList = '목록이 비어있습니다';
  static const String offline = '오프라인';
  static const String online = '온라인';
  static const String connecting = '연결 중...';
  static const String reconnecting = '재연결 중...';

  // Time & Date
  static const String today = '오늘';
  static const String yesterday = '어제';
  static const String tomorrow = '내일';
  static const String now = '지금';
  static const String recently = '최근';
  static const String morning = '오전';
  static const String afternoon = '오후';
  static const String evening = '저녁';
  static const String night = '밤';

  // Days of the week
  static const String monday = '월요일';
  static const String tuesday = '화요일';
  static const String wednesday = '수요일';
  static const String thursday = '목요일';
  static const String friday = '금요일';
  static const String saturday = '토요일';
  static const String sunday = '일요일';

  // Months
  static const String january = '1월';
  static const String february = '2월';
  static const String march = '3월';
  static const String april = '4월';
  static const String may = '5월';
  static const String june = '6월';
  static const String july = '7월';
  static const String august = '8월';
  static const String september = '9월';
  static const String october = '10월';
  static const String november = '11월';
  static const String december = '12월';

  // Search & Filter
  static const String search = '검색';
  static const String searchPlaceholder = '검색어를 입력하세요';
  static const String filter = '필터';
  static const String sort = '정렬';
  static const String sortByLatest = '최신순';
  static const String sortByPopular = '인기순';
  static const String sortByDistance = '거리순';
  static const String sortByAge = '나이순';
  static const String filterAge = '나이';
  static const String filterLocation = '지역';
  static const String filterInterests = '관심사';
  static const String filterOnline = '온라인';

  // Chat & Messaging
  static const String chatTitle = '채팅';
  static const String chatList = '채팅 목록';
  static const String chatNew = '새 채팅';
  static const String chatOnline = '온라인';
  static const String chatOffline = '오프라인';
  static const String chatTyping = '입력 중...';
  static const String chatMessagePlaceholder = '메시지를 입력하세요';
  static const String chatPhoto = '사진';
  static const String chatVideo = '동영상';
  static const String chatLocation = '위치';
  static const String chatEmoji = '이모지';
  static const String chatVoice = '음성';
  static const String chatFile = '파일';

  // Permissions
  static const String permissionCamera = '카메라';
  static const String permissionPhotos = '사진';
  static const String permissionLocation = '위치';
  static const String permissionMicrophone = '마이크';
  static const String permissionContacts = '연락처';
  static const String permissionNotifications = '알림';
  static const String permissionRequired = '권한이 필요합니다';
  static const String permissionDenied = '권한이 거부되었습니다';
  static const String permissionSettings = '설정에서 권한을 허용해주세요';

  /// Figma Variables에서 실제로 정의된 string 값들로 업데이트하세요.
  /// 
  /// 업데이트 방법:
  /// 1. Figma Variables API 접근 권한 확보
  /// 2. curl 명령어로 실제 Variables 추출:
  ///    ```bash
  ///    curl -H "X-Figma-Token: YOUR_TOKEN" \
  ///    "https://api.figma.com/v1/files/dwrMToEyrZlrXr9UYBOlz5/variables/local"
  ///    ```
  /// 3. 'string' 그룹의 Variables만 필터링
  /// 4. 이 파일의 상수들을 실제 Figma 값으로 교체
  /// 
  /// 예시 구조:
  /// ```dart
  /// // Figma Variable: string/app/name -> "SeoulOppa"
  /// static const String appName = 'SeoulOppa';
  /// 
  /// // Figma Variable: string/navigation/home -> "홈"
  /// static const String navigationHome = '홈';
  /// ```
}