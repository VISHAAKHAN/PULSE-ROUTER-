/**
 * AMBULANCE EMERGENCY RESPONSE APPLICATION
 * Complete Master Emergency Lifecycle:
 * Login -> Waiting -> Incident Dispatch -> Navigation -> Arrival ->
 * Telemetry Incident Data -> Intelligent Hospital Selection ->
 * Hospital Navigation -> Live Availability Monitoring -> Dynamic Reroute ->
 * Hospital Arrival -> Patient Handover -> Case Completion -> History Audit
 */

// Application State
const AppState = {
  driver: {
    name: 'ARUN KUMAR',
    id: 'AMB-1042',
    ambulance: 'TN 01 AB 4521',
    status: 'OFF_DUTY' // 'OFF_DUTY' | 'ON_DUTY'
  },
  currentLanguage: (() => {
    try {
      return localStorage.getItem('ambulance_app_lang') || 'en';
    } catch (e) {
      return 'en';
    }
  })(),
  sirenTone: (() => {
    try {
      return localStorage.getItem('ambulance_siren_tone') || 'yelp';
    } catch (e) {
      return 'yelp';
    }
  })(),
  rememberMe: true,
  currentScreen: 'screenLogin',
  activeCase: null,
  map: null,
  hospitalMap: null,
  mapMarkers: {
    ambulance: null,
    destination: null,
    routeLine: null
  },
  hospitalMapMarkers: {
    ambulance: null,
    destination: null,
    routeLine: null
  },
  history: [
    {
      caseId: 'ER-2026-08392',
      incidentType: 'CARDIAC_EMERGENCY',
      incidentLocation: 'T. Nagar, 3rd Street, Chennai',
      hospital: 'Apollo Hospitals, Greams Rd',
      primaryHospital: 'Apollo Hospitals, Greams Rd',
      hospitalChanged: false,
      rerouteReason: null,
      totalDistance: '11.8 km',
      totalDuration: '24 min',
      date: 'Today',
      time: '19:42',
      status: 'COMPLETED'
    },
    {
      caseId: 'ER-2026-08340',
      incidentType: 'TRAUMA_ACCIDENT',
      incidentLocation: 'Velachery Main Road, Chennai',
      hospital: 'MIOT International',
      primaryHospital: 'Apollo Hospitals',
      hospitalChanged: true,
      rerouteReason: 'ICU unavailable at primary hospital',
      totalDistance: '15.4 km',
      totalDuration: '31 min',
      date: 'Today',
      time: '17:15',
      status: 'COMPLETED'
    },
    {
      caseId: 'ER-2026-08291',
      incidentType: 'RESPIRATORY_DISTRESS',
      incidentLocation: 'Guindy Industrial Estate, Chennai',
      hospital: 'Apollo Hospitals, Greams Rd',
      primaryHospital: 'Apollo Hospitals, Greams Rd',
      hospitalChanged: false,
      rerouteReason: null,
      totalDistance: '9.6 km',
      totalDuration: '21 min',
      date: 'Today',
      time: '14:30',
      status: 'COMPLETED'
    }
  ]
};

// ==========================================================================
// Comprehensive Bilingual Translation Dictionary (English & தமிழ்)
// ==========================================================================
const TRANSLATIONS = {
  en: {
    gps_active: 'GPS ACTIVE',
    app_portal_title: 'EMERGENCY DRIVER PORTAL',
    driver_sign_in: 'DRIVER SIGN IN',
    welcome_back: 'Welcome back,',
    sign_in_sub: 'Sign in to access your driver dashboard',
    lbl_driver_id: 'Driver ID / Employee ID',
    lbl_password: 'Password / Secure PIN',
    remember_me: 'Remember me',
    forgot_password: 'Forgot password?',
    login_start_duty: 'LOGIN & START DUTY',
    login_quote_1: 'Every second counts.',
    login_quote_2: 'Your response makes a difference.',
    login_quote_3: 'Drive safe.',
    login_quote_4: 'Save lives.',
    duty_started_title: 'Welcome, Arun Kumar',
    duty_started_sub: 'Duty started • Ambulance Unit TN 01 AB 4521',
    on_duty_badge: '● ON DUTY',
    off_duty_badge: '● OFF DUTY',
    case_closed_title: 'Case Closed',
    case_closed_status: '● COMPLETED',
    case_closed_sub: 'Case closed successfully. Unit ready on duty.',
    on_duty_header: 'ON DUTY',
    off_duty_header: 'OFF DUTY',
    on_duty_sub: 'TN 01 AB 4521 • Arun Kumar',
    off_duty_sub: 'Unit Paused • On Break',
    profile_btn: 'Profile',
    history_btn: 'History',
    active_duty_label: 'ACTIVE ON DUTY',
    active_duty_sub: 'Ready for emergency calls',
    off_duty_label: 'OFF DUTY (ON BREAK)',
    off_duty_sub: 'Emergency dispatch paused',
    go_off_duty_btn: 'GO OFF DUTY',
    resume_duty_btn: 'RESUME ON DUTY',
    waiting_radar_title: 'WAITING FOR EMERGENCY ASSIGNMENT',
    waiting_radar_sub: 'Keep app active. Control Room will dispatch the nearest trauma case.',
    off_duty_radar_title: 'DUTY PAUSED (OFF DUTY)',
    off_duty_radar_sub: 'You are currently on break. Click "Resume On Duty" to accept incoming dispatches.',
    lbl_ambulance_unit: 'AMBULANCE UNIT',
    lbl_driver: 'DRIVER',
    lbl_status: 'STATUS',
    available_dispatch: 'Available for Dispatch',
    paused_dispatch: 'Paused (Off Duty)',
    dispatch_simulator: 'DISPATCH SIMULATOR',
    test_mode: 'TEST MODE',
    test_sub: 'For training & testing purposes only',
    assign_test_btn: 'ASSIGN TEST EMERGENCY',
    incoming_badge: 'INCOMING EMERGENCY CALL',
    high_priority_label: 'High Priority Emergency',
    lbl_case_id: 'Case ID',
    lbl_incident_loc: 'Incident Location',
    lbl_distance: 'Distance',
    lbl_est_eta: 'Est. ETA',
    lbl_severity: 'Severity',
    high_severity: 'High Severity',
    high_priority: 'High Priority',
    slide_to_attend: 'SLIDE TO ATTEND >>>',
    slide_attend_sub: 'SLIDE THUMB OR TAP TO ATTEND',
    nav_to_incident: 'NAVIGATING TO INCIDENT ▲',
    eta_label: 'ETA',
    distance_label: 'DISTANCE',
    traffic_label: 'TRAFFIC',
    optimal_label: 'Optimal',
    remaining_text: 'remaining',
    caller_title: 'EMERGENCY CALLER',
    caller_sub: 'Tap to call',
    call_btn: 'CALL',
    mark_arrived_location: 'MARK AS ARRIVED AT LOCATION',
    arrived_incident_title: 'ARRIVED AT INCIDENT',
    control_room_sync: 'CONTROL ROOM SYNCHRONIZED',
    telemetry_report_header: 'EXTERNAL TELEMETRY REPORT',
    data_received_badge: 'DATA RECEIVED',
    med_issue_class_lbl: 'MEDICAL ISSUE CLASSIFICATION:',
    assigned_hosp_lbl: 'ASSIGNED HOSPITAL DESTINATION:',
    icu_avail_badge: '● ICU AVAILABLE',
    slide_start_trip: 'SLIDE TO START TRIP >>>',
    slide_start_trip_sub: 'SLIDE THUMB TO START HOSPITAL NAVIGATION',
    hosp_nav_badge: 'HOSPITAL NAV ▲',
    dest_updated_title: 'DESTINATION UPDATED',
    ack_btn: 'ACK',
    hosp_dest_lbl: 'HOSPITAL DESTINATION',
    er_open_icu_avail: '● Emergency Dept: Open • ICU: Available',
    arrived_hosp_er_bay: 'ARRIVED AT HOSPITAL ER BAY',
    trip_report_title: 'TRIP REPORT',
    med_class_lbl: 'Medical Classification',
    pickup_loc_lbl: 'Pickup Location',
    dropoff_hosp_lbl: 'Drop-off Hospital',
    total_dist_lbl: 'Total Distance',
    total_dur_lbl: 'Total Duration',
    handover_status_lbl: 'Handover Status:',
    dropped_handed_over_val: 'Dropped & Handed Over',
    back_to_duty_btn: 'BACK TO DUTY',
    driver_profile_title: 'Driver Profile',
    first_responder_role: 'Paramedic First Responder',
    language_heading: 'Language / மொழி',
    siren_sound_heading: 'Emergency Alert Siren',
    license_no_lbl: 'License No:',
    base_station_lbl: 'Base Station:',
    central_hub_val: 'Central Hub (Zone 1)',
    duty_status_lbl: 'Duty Status:',
    end_shift_logout: 'END SHIFT & LOGOUT',
    active_emergency_title: 'Active Emergency In Progress',
    cannot_end_duty_msg: 'You cannot end duty or logout until the active emergency case is completed.',
    return_active_case: 'RETURN TO ACTIVE CASE',
    support_title: 'Control Room Dispatch Support',
    support_sub: 'Emergency Responder Direct Line',
    close_btn: 'CLOSE',
    response_records_title: 'Response Records',
    shift_history_sub: 'Shift Incident History • Unit 4521',
    close_records_btn: 'CLOSE RECORDS',
    primary_hosp_rerouted: 'Primary Hospital Rerouted',
    today: 'Today',
    CARDIAC_EMERGENCY: 'Cardiac Emergency',
    TRAUMA_ACCIDENT: 'Trauma / Accident',
    STROKE_NEURO: 'Acute Stroke',
    RESPIRATORY_DISTRESS: 'Respiratory Distress',
    SEVERE_BURN: 'Severe Burns',
    PEDIATRIC_EMERGENCY: 'Pediatric Code'
  },
  ta: {
    gps_active: 'GPS ஆன் (Active)',
    app_portal_title: 'ஆம்புலன்ஸ் டிரைவர் ஆப்',
    driver_sign_in: 'டிரைவர் லாகின்',
    welcome_back: 'வணக்கம்,',
    sign_in_sub: 'உங்கள் அக்கவுண்டில் லாகின் செய்யவும்',
    lbl_driver_id: 'டிரைவர் ஐடி (Driver ID)',
    lbl_password: 'பாஸ்வேர்ட் / PIN',
    remember_me: 'நினைவில் வைக்கவும்',
    forgot_password: 'பாஸ்வேர்ட் மறந்துவிட்டதா?',
    login_start_duty: 'லாகின் செய்து டியூட்டி தொடங்கு',
    login_quote_1: 'ஒவ்வொரு நொடியும் முக்கியம்.',
    login_quote_2: 'உங்கள் உதவி பல உயிர்களைக் காக்கும்.',
    login_quote_3: 'பாதுகாப்பாக வண்டி ஓட்டுங்கள்.',
    login_quote_4: 'உயிர்களைக் காப்பாற்றுங்கள்.',
    duty_started_title: 'வணக்கம், அருண் குமார்',
    duty_started_sub: 'டியூட்டி தொடங்கியது • வண்டி எண்: TN 01 AB 4521',
    on_duty_badge: '● டியூட்டியில் உள்ளார்',
    off_duty_badge: '● பிரேக் (Break)',
    case_closed_title: 'கேஸ் முடிந்தது (Case Closed)',
    case_closed_status: '● முடிந்தது (Completed)',
    case_closed_sub: 'கேஸ் வெற்றிகரமாக முடிந்தது. அடுத்த எமர்ஜென்சிக்கு தயார்.',
    on_duty_header: 'டியூட்டியில் உள்ளார்',
    off_duty_header: 'பிரேக் (Break)',
    on_duty_sub: 'TN 01 AB 4521 • அருண் குமார்',
    off_duty_sub: 'வண்டி நிறுத்தம் • பிரேக் நேரம்',
    profile_btn: 'ப்ரோஃபைல் (Profile)',
    history_btn: 'ஹிஸ்டரி (History)',
    active_duty_label: 'ஆக்டிவ் டியூட்டி (ON DUTY)',
    active_duty_sub: 'கால் வந்தால் செல்ல தயார்',
    off_duty_label: 'பிரேக் நேரம் (Break)',
    off_duty_sub: 'கால் தற்காலிகமாக வராது',
    go_off_duty_btn: 'பிரேக் எடுக்க (Break)',
    resume_duty_btn: 'மீண்டும் டியூட்டிக்கு வா',
    waiting_radar_title: 'எமர்ஜென்சி கால்க்காக காத்திருக்கிறது',
    waiting_radar_sub: 'ஆப்பை ஆன்ல வையுங்க. கன்ட்ரோல் ரூமிலிருந்து கால் வரும்.',
    off_duty_radar_title: 'டியூட்டி நிறுத்தம் (பிரேக்கில் உள்ளீர்கள்)',
    off_duty_radar_sub: 'நீங்கள் பிரேக்கில் உள்ளீர்கள். புதிய கால்களை ஏற்க "மீண்டும் டியூட்டிக்கு வா" பட்டனை அழுத்தவும்.',
    lbl_ambulance_unit: 'ஆம்புலன்ஸ் எண்',
    lbl_driver: 'டிரைவர் பெயர்',
    lbl_status: 'ஸ்டேட்டஸ் (Status)',
    available_dispatch: 'டியூட்டிக்கு தயார் (Ready)',
    paused_dispatch: 'பிரேக்கில் உள்ளார் (Paused)',
    dispatch_simulator: 'டெஸ்ட் கால் (Simulator)',
    test_mode: 'டெஸ்ட் மோட் (Test)',
    test_sub: 'ட்ரைனிங் மற்றும் டெஸ்டிங்கிற்கு மட்டும்',
    assign_test_btn: 'டெஸ்ட் கால் அனுப்பு',
    incoming_badge: 'எமர்ஜென்சி கால் வருது!',
    high_priority_label: 'அவசர எமர்ஜென்சி கால்',
    lbl_case_id: 'கேஸ் ஐடி (Case ID)',
    lbl_incident_loc: 'சம்பவம் நடந்த இடம்',
    lbl_distance: 'தூரம் (Distance)',
    lbl_est_eta: 'நேரம் (ETA)',
    lbl_severity: 'தீவிரம் (Severity)',
    high_severity: 'அதிக தீவிரம் (High)',
    high_priority: 'அவசர முக்கியத்துவம்',
    slide_to_attend: 'ஏற்க ஸ்வைப் செய்யவும் >>>',
    slide_attend_sub: 'காலை ஏற்க விரலை நகர்த்தவும்',
    nav_to_incident: 'சம்பவ இடத்திற்கு வழி காட்டுது ▲',
    eta_label: 'நேரம் (ETA)',
    distance_label: 'தூரம்',
    traffic_label: 'டிராஃபிக் (Traffic)',
    optimal_label: 'குறைவு (Normal)',
    remaining_text: 'மீதம்',
    caller_title: 'கூப்பிட்டவர் (Caller)',
    caller_sub: 'கால் செய்ய தொடவும்',
    call_btn: 'கால் செய்',
    mark_arrived_location: 'சம்பவ இடத்திற்கு வந்தாச்சு (Arrived)',
    arrived_incident_title: 'சம்பவ இடத்திற்கு வந்தாச்சு!',
    control_room_sync: 'கன்ட்ரோல் ரூமுக்கு தகவல் போயாச்சு',
    telemetry_report_header: 'மருத்துவ ரிப்போர்ட் (Report)',
    data_received_badge: 'டேட்டா வந்தது (Received)',
    med_issue_class_lbl: 'நோயாளிக்கு என்ன பிரச்சனை:',
    assigned_hosp_lbl: 'செல்ல வேண்டிய ஆஸ்பத்திரி (Hospital):',
    icu_avail_badge: '● ICU பெட் இருக்கு',
    slide_start_trip: 'ட்ரிப் தொடங்க ஸ்வைப் செய் >>>',
    slide_start_trip_sub: 'ஆஸ்பத்திரிக்கு போக ஸ்லைடரை நகர்த்தவும்',
    hosp_nav_badge: 'ஆஸ்பத்திரிக்கு வழி காட்டுது ▲',
    dest_updated_title: 'ஆஸ்பத்திரி மாற்றப்பட்டது!',
    ack_btn: 'சரி (OK)',
    hosp_dest_lbl: 'செல்ல வேண்டிய ஆஸ்பத்திரி',
    er_open_icu_avail: '● எமர்ஜென்சி வார்டு: ஓபன் • ICU: இருக்கு',
    arrived_hosp_er_bay: 'ஆஸ்பத்திரி ER-க்கு வந்தாச்சு',
    trip_report_title: 'ட்ரிப் ரிப்போர்ட் (Trip Report)',
    med_class_lbl: 'மருத்துவ பிரச்சனை',
    pickup_loc_lbl: 'நோயாளி ஏற்றிய இடம்',
    dropoff_hosp_lbl: 'சேர்த்த ஆஸ்பத்திரி',
    total_dist_lbl: 'மொத்த தூரம்',
    total_dur_lbl: 'மொத்த நேரம்',
    handover_status_lbl: 'நோயாளி நிலை:',
    dropped_handed_over_val: 'டாக்டரிடம் ஒப்படைச்சாச்சு',
    back_to_duty_btn: 'மீண்டும் டியூட்டிக்கு போ',
    driver_profile_title: 'டிரைவர் விவரம் (Profile)',
    first_responder_role: 'முதலுதவி பாராமெடிக் (First Responder)',
    language_heading: 'மொழி / Language',
    siren_sound_heading: 'எமர்ஜென்சி சைரன் ஒலி',
    license_no_lbl: 'டிரைவிங் லைசென்ஸ் எண்:',
    base_station_lbl: 'மெயின் சென்டர்:',
    central_hub_val: 'சென்ட்ரல் ஹப் (மண்டலம் 1)',
    duty_status_lbl: 'டியூட்டி ஸ்டேட்டஸ்:',
    end_shift_logout: 'ஷிப்ட் முடிச்சு லாக்அவுட் செய்',
    active_emergency_title: 'எமர்ஜென்சி ட்ரிப் நடக்குது',
    cannot_end_duty_msg: 'ட்ரிப் முடியாமல் லாக்அவுட் செய்ய முடியாது.',
    return_active_case: 'ட்ரிப்புக்கு திரும்பு',
    support_title: 'கன்ட்ரோல் ரூம் உதவி',
    support_sub: 'எமர்ஜென்சி நேரடி ஹெல்ப்லைன்',
    close_btn: 'மூடு (Close)',
    response_records_title: 'பயண விவரங்கள் (History)',
    shift_history_sub: 'இன்றைய ஷிப்ட் பதிவுகள் • Unit 4521',
    close_records_btn: 'மூடு (Close)',
    primary_hosp_rerouted: 'ஆஸ்பத்திரி மாற்றப்பட்டது',
    today: 'இன்று (Today)',
    CARDIAC_EMERGENCY: 'மாரடைப்பு / நெஞ்சுவலி (Cardiac)',
    TRAUMA_ACCIDENT: 'விபத்து / காயம் (Trauma)',
    STROKE_NEURO: 'பக்கவாதம் (Stroke)',
    RESPIRATORY_DISTRESS: 'மூச்சுத் திணறல் (Respiratory)',
    SEVERE_BURN: 'தீக்காயம் (Burns)',
    PEDIATRIC_EMERGENCY: 'குழந்தைகள் அவசர சிகிச்சை (Pediatric)'
  }
};

function t(key) {
  const lang = AppState.currentLanguage || 'en';
  if (TRANSLATIONS[lang] && TRANSLATIONS[lang][key] !== undefined) {
    return TRANSLATIONS[lang][key];
  }
  if (TRANSLATIONS.en && TRANSLATIONS.en[key] !== undefined) {
    return TRANSLATIONS.en[key];
  }
  return key;
}

function setLanguage(lang) {
  if (!TRANSLATIONS[lang]) return;
  AppState.currentLanguage = lang;
  try {
    localStorage.setItem('ambulance_app_lang', lang);
  } catch (e) {}

  AudioEngine.playAcknowledgeBeep();
  applyLanguage();
}

function applyLanguage() {
  const lang = AppState.currentLanguage || 'en';

  document.documentElement.lang = lang;
  if (document.body) {
    document.body.classList.toggle('lang-ta', lang === 'ta');
  }

  // 1. Update Profile Language Switcher Buttons
  const langIndicator = document.getElementById('currentLangIndicator');
  const langBtnEn = document.getElementById('langBtnEn');
  const langBtnTa = document.getElementById('langBtnTa');

  if (langIndicator) {
    langIndicator.textContent = lang === 'ta' ? 'தமிழ்' : 'ENGLISH';
  }

  if (langBtnEn && langBtnTa) {
    if (lang === 'ta') {
      langBtnTa.className = 'py-2 rounded-lg text-xs font-black transition-all flex items-center justify-center gap-1 bg-emerald-600 text-white shadow-sm cursor-pointer';
      langBtnEn.className = 'py-2 rounded-lg text-xs font-black transition-all flex items-center justify-center gap-1 text-slate-400 hover:text-white hover:bg-slate-800 cursor-pointer';
    } else {
      langBtnEn.className = 'py-2 rounded-lg text-xs font-black transition-all flex items-center justify-center gap-1 bg-emerald-600 text-white shadow-sm cursor-pointer';
      langBtnTa.className = 'py-2 rounded-lg text-xs font-black transition-all flex items-center justify-center gap-1 text-slate-400 hover:text-white hover:bg-slate-800 cursor-pointer';
    }
  }

  // 2. Translate all elements with data-i18n
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (key) {
      el.textContent = t(key);
    }
  });

  // 3. Update dynamic state elements
  updateDutyModeUI();
  renderHistoryRecords();

  if (window.lucide) {
    try { window.lucide.createIcons(); } catch (e) {}
  }
}

// 1. Configurable Medical Categories & Criteria
const MEDICAL_INCIDENT_TYPES = {
  CARDIAC_EMERGENCY: {
    label: 'Cardiac Emergency',
    sublabel: 'Acute Chest Pain / MI',
    icon: 'heart-pulse',
    color: 'text-rose-400',
    specialty: 'Cardiology & Cath Lab',
    requiredDept: 'CARDIAC'
  },
  TRAUMA_ACCIDENT: {
    label: 'Trauma / Accident',
    sublabel: 'High-Speed Multi-Injury',
    icon: 'ambulance',
    color: 'text-amber-400',
    specialty: 'Trauma Center & Surgery',
    requiredDept: 'TRAUMA'
  },
  STROKE_NEURO: {
    label: 'Acute Stroke',
    sublabel: 'CVA / Hemiplegia',
    icon: 'brain',
    color: 'text-purple-400',
    specialty: 'Neurology & Stroke ICU',
    requiredDept: 'NEURO'
  },
  RESPIRATORY_DISTRESS: {
    label: 'Respiratory Distress',
    sublabel: 'Severe Acute Hypoxia',
    icon: 'wind',
    color: 'text-sky-400',
    specialty: 'Pulmonology & Ventilator Care',
    requiredDept: 'RESPIRATORY'
  },
  SEVERE_BURN: {
    label: 'Severe Burns',
    sublabel: 'Critical Thermal Trauma',
    icon: 'flame',
    color: 'text-orange-400',
    specialty: 'Burn Unit & Critical Care',
    requiredDept: 'BURNS'
  },
  PEDIATRIC_EMERGENCY: {
    label: 'Pediatric Code',
    sublabel: 'Infant / Child Critical Care',
    icon: 'baby',
    color: 'text-emerald-400',
    specialty: 'Pediatric ICU & Surgery',
    requiredDept: 'PEDIATRIC'
  }
};

// 2. Chennai Tertiary Emergency Trauma Centers Database
const CHENNAI_HOSPITALS = [
  {
    id: 'hosp-apollo',
    name: 'Apollo Hospitals, Greams Rd',
    shortName: 'Apollo Hospitals',
    lat: 13.0604,
    lng: 80.2496,
    phone: '+91 44 2829 0200',
    erStatus: 'OPEN',
    icuBeds: 4,
    capabilities: ['CARDIAC', 'TRAUMA', 'NEURO', 'RESPIRATORY'],
    tags: ['Emergency Dept. Open', 'ICU Available (4 beds)', 'Cardiac Cath Lab']
  },
  {
    id: 'hosp-miot',
    name: 'MIOT International, Manapakkam',
    shortName: 'MIOT International',
    lat: 13.0182,
    lng: 80.1772,
    phone: '+91 44 4200 2288',
    erStatus: 'OPEN',
    icuBeds: 6,
    capabilities: ['TRAUMA', 'CARDIAC', 'NEURO', 'RESPIRATORY', 'BURNS'],
    tags: ['Level 1 Trauma Care', 'ICU Available (6 beds)', 'Emergency Surgery']
  },
  {
    id: 'hosp-fortis',
    name: 'Fortis Malar Hospital, Adyar',
    shortName: 'Fortis Malar',
    lat: 13.0068,
    lng: 80.2573,
    phone: '+91 44 4289 2222',
    erStatus: 'OPEN',
    icuBeds: 2,
    capabilities: ['CARDIAC', 'NEURO', 'RESPIRATORY'],
    tags: ['Cardiac Care Unit', 'ICU Available (2 beds)', 'Neurology ICU']
  },
  {
    id: 'hosp-gleneagles',
    name: 'Gleneagles Global Health City, Perumbakkam',
    shortName: 'Gleneagles Global',
    lat: 12.9056,
    lng: 80.1983,
    phone: '+91 44 4477 7000',
    erStatus: 'OPEN',
    icuBeds: 5,
    capabilities: ['TRAUMA', 'CARDIAC', 'PEDIATRIC', 'RESPIRATORY'],
    tags: ['Emergency Trauma OR', 'ICU Available (5 beds)', 'Pediatric Critical Care']
  },
  {
    id: 'hosp-kauvery',
    name: 'Kauvery Hospital, Alwarpet',
    shortName: 'Kauvery Hospital',
    lat: 13.0336,
    lng: 80.2505,
    phone: '+91 44 4000 6000',
    erStatus: 'OPEN',
    icuBeds: 3,
    capabilities: ['NEURO', 'CARDIAC', 'RESPIRATORY', 'PEDIATRIC'],
    tags: ['Stroke Care Unit', 'ICU Available (3 beds)', 'Cath Lab Active']
  },
  {
    id: 'hosp-rgggh',
    name: 'Govt. General Trauma Hospital, Park Town',
    shortName: 'Govt. General Hospital',
    lat: 13.0827,
    lng: 80.2707,
    phone: '+91 44 2530 5000',
    erStatus: 'OPEN',
    icuBeds: 8,
    capabilities: ['TRAUMA', 'BURNS', 'CARDIAC', 'RESPIRATORY'],
    tags: ['Govt. Trauma Base', 'ICU Available (8 beds)', '24/7 Blood Bank']
  }
];

// 3. Multi-Criteria Hospital Ranking Algorithm
const HospitalRankingEngine = {
  calculateDistanceKm(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth radius in km
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = 
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return parseFloat((R * c).toFixed(1));
  },

  evaluate(incidentTypeKey, incidentLocation) {
    const typeConfig = MEDICAL_INCIDENT_TYPES[incidentTypeKey] || MEDICAL_INCIDENT_TYPES.CARDIAC_EMERGENCY;
    const reqDept = typeConfig.requiredDept;

    const scored = CHENNAI_HOSPITALS.map(hosp => {
      const dist = this.calculateDistanceKm(incidentLocation.latitude, incidentLocation.longitude, hosp.lat, hosp.lng);
      const eta = Math.max(6, Math.round(dist * 2.2 + 2)); // estimated minutes

      let score = 100;

      // Capability Match (40 pts)
      const hasSpecialty = hosp.capabilities.includes(reqDept);
      score += hasSpecialty ? 40 : -40;

      // ICU Availability (30 pts)
      score += hosp.icuBeds * 5;

      // ER Status (20 pts)
      score += hosp.erStatus === 'OPEN' ? 20 : -100;

      // Distance Suitability (10 pts max)
      score -= dist * 2;

      return {
        ...hosp,
        distanceKm: dist,
        etaMinutes: eta,
        computedScore: score,
        hasRequiredSpecialty: hasSpecialty
      };
    });

    scored.sort((a, b) => b.computedScore - a.computedScore);

    return {
      primary: scored[0] || scored[0],
      alternate: scored[1] || scored[0],
      allRanked: scored
    };
  }
};

// Test Emergency Scenarios Pool
const TEST_EMERGENCY_SCENARIOS = [
  {
    address: 'GST Road, Guindy Junction, Chennai',
    complaint: 'Acute Cardiac / Severe Chest Pain',
    lat: 13.0067,
    lng: 80.2025,
    startLat: 13.0450,
    startLng: 80.2000,
    eta: 12,
    dist: 5.4,
    phone: '+91 94440 11223'
  },
  {
    address: 'Anna Nagar, 2nd Avenue, Chennai',
    complaint: 'Road Traffic Accident (Multiple Trauma)',
    lat: 13.0850,
    lng: 80.2101,
    startLat: 13.0450,
    startLng: 80.2000,
    eta: 10,
    dist: 4.8,
    phone: '+91 98765 43210'
  },
  {
    address: 'OMR Road, Thoraipakkam, Chennai',
    complaint: 'Acute Stroke / Sudden Weakness',
    lat: 12.9425,
    lng: 80.2370,
    startLat: 13.0450,
    startLng: 80.2000,
    eta: 14,
    dist: 5.1,
    phone: '+91 98401 23456'
  }
];

let scenarioIndex = 0;

/* ==========================================================================
   1. Audio Synthesizer Engine (Emergency Siren & Alerts)
   ========================================================================== */
const AudioEngine = {
  ctx: null,
  sirenInterval: null,
  activeNodes: [],
  isPlayingSiren: false,
  previewTimeout: null,

  init() {
    if (!this.ctx) {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (AudioCtx) {
        this.ctx = new AudioCtx();
      }
    }
  },

  makeDistortionCurve(amount = 25) {
    const n_samples = 44100;
    const curve = new Float32Array(n_samples);
    const deg = Math.PI / 180;
    for (let i = 0; i < n_samples; ++i) {
      const x = (i * 2) / n_samples - 1;
      curve[i] = ((3 + amount) * x * 20 * deg) / (Math.PI + amount * Math.abs(x));
    }
    return curve;
  },

  startEmergencySiren() {
    try {
      this.init();
      if (!this.ctx) return;
      if (this.ctx.state === 'suspended') this.ctx.resume();

      this.stopEmergencySiren();
      this.isPlayingSiren = true;

      const tone = AppState.sirenTone || 'yelp';

      switch (tone) {
        case 'yelp':
          this.playRapidYelpSiren();
          break;
        case 'q2b':
          this.playQ2BSiren();
          break;
        case 'rumbler':
          this.playRumblerSiren();
          break;
        case 'airhorn':
          this.playAirHornSiren();
          break;
        case 'hilo':
          this.playHiLoSiren();
          break;
        case 'buzzer':
          this.playBuzzerSiren();
          break;
        default:
          this.playRapidYelpSiren();
          break;
      }

      if (navigator.vibrate) {
        navigator.vibrate([200, 50, 200, 50, 300]);
      }
    } catch (e) {
      console.warn('Audio siren note:', e);
    }
  },

  // ⚡ 1. Rapid Yelp Siren (Default Primary Tone - 4.5 Hz Fast Upward Acoustic Sweep)
  playRapidYelpSiren() {
    const step = () => {
      if (!this.isPlayingSiren || !this.ctx) return;
      const now = this.ctx.currentTime;

      const osc = this.ctx.createOscillator();
      const osc2 = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      const filter = this.ctx.createBiquadFilter();

      osc.type = 'sawtooth';
      osc2.type = 'square';

      // Rapid upward acoustic sweep 750 Hz -> 1450 Hz
      osc.frequency.setValueAtTime(750, now);
      osc.frequency.exponentialRampToValueAtTime(1450, now + 0.21);

      osc2.frequency.setValueAtTime(755, now);
      osc2.frequency.exponentialRampToValueAtTime(1460, now + 0.21);

      filter.type = 'lowpass';
      filter.frequency.setValueAtTime(3400, now);

      gain.gain.setValueAtTime(0.32, now);
      gain.gain.setValueAtTime(0.32, now + 0.20);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.23);

      osc.connect(filter);
      osc2.connect(filter);
      filter.connect(gain);
      gain.connect(this.ctx.destination);

      osc.start(now);
      osc2.start(now);
      osc.stop(now + 0.23);
      osc2.stop(now + 0.23);
      this.activeNodes.push(osc, osc2, filter, gain);
    };

    step();
    this.sirenInterval = setInterval(step, 240);
  },

  // 🚨 2. Federal Q2B Beast Siren
  playQ2BSiren() {
    const step = () => {
      if (!this.isPlayingSiren || !this.ctx) return;
      const now = this.ctx.currentTime;
      const osc1 = this.ctx.createOscillator();
      const osc2 = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      const filter = this.ctx.createBiquadFilter();

      osc1.type = 'sawtooth';
      osc2.type = 'sawtooth';
      osc1.frequency.setValueAtTime(280, now);
      osc1.frequency.exponentialRampToValueAtTime(1180, now + 1.5);
      osc1.frequency.exponentialRampToValueAtTime(360, now + 3.2);

      osc2.frequency.setValueAtTime(284, now);
      osc2.frequency.exponentialRampToValueAtTime(1192, now + 1.5);
      osc2.frequency.exponentialRampToValueAtTime(365, now + 3.2);

      filter.type = 'lowpass';
      filter.frequency.setValueAtTime(2400, now);

      gain.gain.setValueAtTime(0.35, now);
      gain.gain.setValueAtTime(0.45, now + 1.5);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 3.2);

      osc1.connect(filter);
      osc2.connect(filter);
      filter.connect(gain);
      gain.connect(this.ctx.destination);

      osc1.start(now);
      osc2.start(now);
      osc1.stop(now + 3.25);
      osc2.stop(now + 3.25);
      this.activeNodes.push(osc1, osc2, gain, filter);
    };

    step();
    this.sirenInterval = setInterval(step, 3300);
  },

  // 💥 4. The Rumbler Sub-Bass + Yelp
  playRumblerSiren() {
    const step = () => {
      if (!this.isPlayingSiren || !this.ctx) return;
      const now = this.ctx.currentTime;
      const osc = this.ctx.createOscillator();
      const oscSub = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      const subGain = this.ctx.createGain();

      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(750, now);
      osc.frequency.exponentialRampToValueAtTime(1550, now + 0.22);
      gain.gain.setValueAtTime(0.35, now);
      gain.gain.exponentialRampToValueAtTime(0.01, now + 0.23);

      oscSub.type = 'sine';
      oscSub.frequency.setValueAtTime(65, now);
      subGain.gain.setValueAtTime(0.65, now);
      subGain.gain.exponentialRampToValueAtTime(0.05, now + 0.22);

      osc.connect(gain);
      oscSub.connect(subGain);
      gain.connect(this.ctx.destination);
      subGain.connect(this.ctx.destination);

      osc.start(now);
      oscSub.start(now);
      osc.stop(now + 0.23);
      oscSub.stop(now + 0.23);
      this.activeNodes.push(osc, oscSub, gain, subGain);
    };

    step();
    this.sirenInterval = setInterval(step, 240);
  },

  // 📢 5. Air Horn Double Blast
  playAirHornSiren() {
    const step = () => {
      if (!this.isPlayingSiren || !this.ctx) return;
      const now = this.ctx.currentTime;
      [
        { t: 0, dur: 0.28 },
        { t: 0.38, dur: 0.48 }
      ].forEach(blast => {
        [311.13, 369.99, 466.16].forEach(f => {
          const osc = this.ctx.createOscillator();
          const gain = this.ctx.createGain();
          osc.type = 'sawtooth';
          osc.frequency.setValueAtTime(f, now + blast.t);
          gain.gain.setValueAtTime(0.3, now + blast.t);
          gain.gain.exponentialRampToValueAtTime(0.001, now + blast.t + blast.dur);
          osc.connect(gain);
          gain.connect(this.ctx.destination);
          osc.start(now + blast.t);
          osc.stop(now + blast.t + blast.dur);
          this.activeNodes.push(osc, gain);
        });
      });
    };

    step();
    this.sirenInterval = setInterval(step, 1150);
  },

  // 🚨 6. Classic European Hi-Lo
  playHiLoSiren() {
    const step = () => {
      if (!this.isPlayingSiren || !this.ctx) return;
      const now = this.ctx.currentTime;
      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      osc.type = 'sawtooth';
      osc.frequency.setValueAtTime(700, now);
      osc.frequency.setValueAtTime(950, now + 0.32);
      gain.gain.setValueAtTime(0.28, now);
      gain.gain.setValueAtTime(0.28, now + 0.62);
      gain.gain.exponentialRampToValueAtTime(0.001, now + 0.64);
      osc.connect(gain);
      gain.connect(this.ctx.destination);
      osc.start(now);
      osc.stop(now + 0.64);
      this.activeNodes.push(osc, gain);
    };

    step();
    this.sirenInterval = setInterval(step, 650);
  },

  // 📟 7. Digital Buzzer
  playBuzzerSiren() {
    const step = () => {
      if (!this.isPlayingSiren || !this.ctx) return;
      const now = this.ctx.currentTime;
      [0, 0.12, 0.24].forEach((offset) => {
        const osc1 = this.ctx.createOscillator();
        const osc2 = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc1.type = 'square';
        osc2.type = 'sawtooth';
        osc1.frequency.setValueAtTime(2400, now + offset);
        osc2.frequency.setValueAtTime(2850, now + offset);
        gain.gain.setValueAtTime(0.25, now + offset);
        gain.gain.exponentialRampToValueAtTime(0.001, now + offset + 0.08);
        osc1.connect(gain);
        osc2.connect(gain);
        gain.connect(this.ctx.destination);
        osc1.start(now + offset);
        osc2.start(now + offset);
        osc1.stop(now + offset + 0.085);
        osc2.stop(now + offset + 0.085);
        this.activeNodes.push(osc1, osc2, gain);
      });
    };

    step();
    this.sirenInterval = setInterval(step, 600);
  },

  stopEmergencySiren() {
    this.isPlayingSiren = false;
    if (this.sirenInterval) {
      clearInterval(this.sirenInterval);
      this.sirenInterval = null;
    }
    if (this.previewTimeout) {
      clearTimeout(this.previewTimeout);
      this.previewTimeout = null;
    }
    this.activeNodes.forEach(node => {
      try {
        if (node.stop) node.stop();
        if (node.disconnect) node.disconnect();
      } catch (e) {}
    });
    this.activeNodes = [];

    if (navigator.vibrate) {
      navigator.vibrate(0);
    }
  },

  previewSirenTone(tone) {
    const previousTone = AppState.sirenTone;
    AppState.sirenTone = tone;
    this.startEmergencySiren();
    
    // Auto-stop preview after 3.2 seconds
    if (this.previewTimeout) clearTimeout(this.previewTimeout);
    this.previewTimeout = setTimeout(() => {
      this.stopEmergencySiren();
      AppState.sirenTone = previousTone;
    }, 3200);
  },

  playAcknowledgeBeep() {
    try {
      this.init();
      if (!this.ctx) return;
      if (this.ctx.state === 'suspended') this.ctx.resume();

      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();
      osc.type = 'sine';
      osc.frequency.setValueAtTime(1046.50, this.ctx.currentTime);
      gain.gain.setValueAtTime(0.25, this.ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + 0.18);

      osc.connect(gain);
      gain.connect(this.ctx.destination);

      osc.start();
      osc.stop(this.ctx.currentTime + 0.2);
    } catch (e) {}
  },

  playAlertChime() {
    try {
      this.init();
      if (!this.ctx) return;
      if (this.ctx.state === 'suspended') this.ctx.resume();

      [880, 587.33, 880].forEach((freq, i) => {
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.frequency.value = freq;
        gain.gain.setValueAtTime(0.2, this.ctx.currentTime + i * 0.15);
        gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + i * 0.15 + 0.3);

        osc.connect(gain);
        gain.connect(this.ctx.destination);

        osc.start(this.ctx.currentTime + i * 0.15);
        osc.stop(this.ctx.currentTime + i * 0.15 + 0.35);
      });
    } catch (e) {}
  },

  playArrivalChime() {
    try {
      this.init();
      if (!this.ctx) return;
      if (this.ctx.state === 'suspended') this.ctx.resume();

      [523.25, 659.25, 783.99, 1046.50].forEach((freq, i) => {
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.frequency.value = freq;
        gain.gain.setValueAtTime(0.2, this.ctx.currentTime + i * 0.12);
        gain.gain.exponentialRampToValueAtTime(0.01, this.ctx.currentTime + i * 0.12 + 0.35);

        osc.connect(gain);
        gain.connect(this.ctx.destination);

        osc.start(this.ctx.currentTime + i * 0.12);
        osc.stop(this.ctx.currentTime + i * 0.12 + 0.4);
      });
    } catch (e) {}
  }
};

/* ==========================================================================
   2. Screen Navigation & Flow Controller
   ========================================================================== */
function navigateToScreen(screenId) {
  const allScreens = [
    'screenLogin',
    'screenWaiting',
    'screenIncomingCall',
    'screenNavigation',
    'screenArrivedIncident',
    'screenHospitalNavigation',
    'screenCompleted'
  ];

  allScreens.forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      if (id === screenId) {
        el.classList.remove('hidden');
      } else {
        el.classList.add('hidden');
      }
    }
  });

  AppState.currentScreen = screenId;

  if (screenId === 'screenNavigation') {
    setTimeout(initOrUpdateMap, 50);
    setTimeout(() => { if (AppState.map) AppState.map.invalidateSize(); }, 150);
    setTimeout(() => { if (AppState.map) AppState.map.invalidateSize(); }, 400);
  }

  if (screenId === 'screenHospitalNavigation') {
    setTimeout(initOrUpdateHospitalMap, 50);
    setTimeout(() => { if (AppState.hospitalMap) AppState.hospitalMap.invalidateSize(); }, 150);
    setTimeout(() => { if (AppState.hospitalMap) AppState.hospitalMap.invalidateSize(); }, 400);
  }

  if (window.lucide) {
    try { window.lucide.createIcons(); } catch (e) {}
  }
}

function getFormattedTime() {
  const now = new Date();
  const h = String(now.getHours()).padStart(2, '0');
  const m = String(now.getMinutes()).padStart(2, '0');
  const s = String(now.getSeconds()).padStart(2, '0');
  return `${h}:${m}:${s}`;
}

// Hardware Status Bar Clock
function initClock() {
  const clockEl = document.getElementById('liveClock');
  const update = () => {
    if (clockEl) {
      const now = new Date();
      clockEl.textContent = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;
    }
  };
  update();
  setInterval(update, 1000);
}

/* ==========================================================================
   3. Screen 1: Login Flow & Form Behaviors
   ========================================================================== */
function initLoginFlow() {
  const driverIdInput = document.getElementById('driverIdInput');
  const passwordInput = document.getElementById('passwordInput');
  const togglePasswordBtn = document.getElementById('togglePasswordBtn');
  const passwordEyeIcon = document.getElementById('passwordEyeIcon');
  const rememberCheckbox = document.getElementById('rememberCheckbox');
  const forgotPasswordBtn = document.getElementById('forgotPasswordBtn');
  const loginSubmitBtn = document.getElementById('loginSubmitBtn');

  if (togglePasswordBtn && passwordInput && passwordEyeIcon) {
    togglePasswordBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const isPass = passwordInput.getAttribute('type') === 'password';
      passwordInput.setAttribute('type', isPass ? 'text' : 'password');
      passwordEyeIcon.setAttribute('data-lucide', isPass ? 'eye-off' : 'eye');
      if (window.lucide) window.lucide.createIcons();
    });
  }

  if (rememberCheckbox) {
    rememberCheckbox.parentElement.addEventListener('click', (e) => {
      e.preventDefault();
      AppState.rememberMe = !AppState.rememberMe;
      if (AppState.rememberMe) {
        rememberCheckbox.className = 'w-4 h-4 rounded bg-emergency flex items-center justify-center text-white cursor-pointer transition-colors shadow-sm';
        rememberCheckbox.innerHTML = '<i data-lucide="check" class="w-3 h-3 stroke-[3]"></i>';
      } else {
        rememberCheckbox.className = 'w-4 h-4 rounded border border-slate-300 bg-white flex items-center justify-center cursor-pointer transition-colors shadow-sm';
        rememberCheckbox.innerHTML = '';
      }
      if (window.lucide) window.lucide.createIcons();
    });
  }

  if (forgotPasswordBtn) {
    forgotPasswordBtn.addEventListener('click', (e) => {
      e.preventDefault();
      alert('Contact Hospital Control Room Dispatch: 108 / +91 44 2888 0108');
    });
  }

  const handleLogin = () => {
    const driverId = driverIdInput ? driverIdInput.value.trim() : 'AMB-1042';
    const password = passwordInput ? passwordInput.value.trim() : '1042';

    if (!driverId || !password) {
      alert('Please provide Driver ID and PIN');
      return;
    }

    AppState.driver.status = 'ON_DUTY';
    AudioEngine.playAcknowledgeBeep();

    navigateToScreen('screenWaiting');
    showDutyStartedPopup('Arun Kumar', 'TN 01 AB 4521');
  };

  if (loginSubmitBtn) {
    loginSubmitBtn.addEventListener('click', (e) => {
      e.preventDefault();
      handleLogin();
    });
  }

  [driverIdInput, passwordInput].forEach(inp => {
    if (inp) {
      inp.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          e.preventDefault();
          handleLogin();
        }
      });
    }
  });
}

function showDutyStartedPopup(driverName, ambulanceUnit) {
  const popup = document.getElementById('dutyStartedPopup');
  const title = document.getElementById('dutyPopupTitle');
  const sub = document.getElementById('dutyPopupSub');
  const closeBtn = document.getElementById('closeDutyPopupBtn');

  if (!popup) return;
  if (title) title.textContent = t('duty_started_title');
  if (sub) sub.textContent = t('duty_started_sub');

  popup.classList.add('show');
  const hidePopup = () => popup.classList.remove('show');
  if (closeBtn) closeBtn.onclick = hidePopup;
  setTimeout(hidePopup, 4000);
}

/* ==========================================================================
   4. Screen 3: Waiting Screen & Duty Mode Controller
   ========================================================================== */
function updateDutyModeUI() {
  const isDuty = AppState.driver.status === 'ON_DUTY';

  const headerDot = document.getElementById('headerDutyDot');
  const headerText = document.getElementById('headerDutyText');
  const headerSub = document.getElementById('headerDutySub');
  const badgeDot = document.getElementById('dutyStatusBadgeDot');
  const badgeLabel = document.getElementById('dutyStatusBadgeLabel');
  const badgeSub = document.getElementById('dutyStatusBadgeSub');
  const iconBadge = document.getElementById('dutyStatusIconBadge');
  const toggleBtn = document.getElementById('toggleDutyModeBtn');
  const toggleIcon = document.getElementById('toggleDutyModeIcon');
  const toggleText = document.getElementById('toggleDutyModeText');
  const radarCircle = document.getElementById('waitingRadarCircle');
  const radarTitle = document.getElementById('radarMainTitle');
  const radarSub = document.getElementById('radarMainSub');
  const unitStatus = document.getElementById('unitCardStatusBadge');
  const profileBadge = document.getElementById('profileDutyStatusBadge');

  if (isDuty) {
    if (headerDot) headerDot.className = 'w-3 h-3 rounded-full bg-emerald-500 animate-pulse';
    if (headerText) headerText.textContent = t('on_duty_header');
    if (headerSub) headerSub.textContent = t('on_duty_sub');

    if (iconBadge) iconBadge.className = 'w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 border border-emerald-200 flex items-center justify-center shrink-0';
    if (badgeDot) badgeDot.className = 'w-2 h-2 rounded-full bg-emerald-500 animate-pulse';
    if (badgeLabel) badgeLabel.textContent = t('active_duty_label');
    if (badgeSub) badgeSub.textContent = t('active_duty_sub');

    if (toggleBtn) toggleBtn.className = 'px-3 py-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-extrabold text-[10.5px] uppercase tracking-wider transition-all flex items-center gap-1.5 shadow-sm active:scale-95 cursor-pointer';
    if (toggleIcon) toggleIcon.setAttribute('data-lucide', 'coffee');
    if (toggleText) toggleText.textContent = t('go_off_duty_btn');

    if (radarCircle) radarCircle.classList.remove('off-duty');
    if (radarTitle) radarTitle.textContent = t('waiting_radar_title');
    if (radarSub) radarSub.textContent = t('waiting_radar_sub');

    if (unitStatus) {
      unitStatus.className = 'text-xs font-extrabold text-emerald-600 flex items-center gap-1.5';
      unitStatus.innerHTML = `<span class="w-2 h-2 rounded-full bg-emerald-500"></span> ${t('available_dispatch')}`;
    }
    if (profileBadge) {
      profileBadge.className = 'font-extrabold text-emerald-400';
      profileBadge.textContent = t('on_duty_badge');
    }
  } else {
    if (headerDot) headerDot.className = 'w-3 h-3 rounded-full bg-amber-400';
    if (headerText) headerText.textContent = t('off_duty_header');
    if (headerSub) headerSub.textContent = t('off_duty_sub');

    if (iconBadge) iconBadge.className = 'w-9 h-9 rounded-xl bg-amber-50 text-amber-600 border border-amber-200 flex items-center justify-center shrink-0';
    if (badgeDot) badgeDot.className = 'w-2 h-2 rounded-full bg-amber-500';
    if (badgeLabel) badgeLabel.textContent = t('off_duty_label');
    if (badgeSub) badgeSub.textContent = t('off_duty_sub');

    if (toggleBtn) toggleBtn.className = 'px-3 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-extrabold text-[10.5px] uppercase tracking-wider transition-all flex items-center gap-1.5 shadow-md shadow-emerald-600/30 active:scale-95 cursor-pointer';
    if (toggleIcon) toggleIcon.setAttribute('data-lucide', 'power');
    if (toggleText) toggleText.textContent = t('resume_duty_btn');

    if (radarCircle) radarCircle.classList.add('off-duty');
    if (radarTitle) radarTitle.textContent = t('off_duty_radar_title');
    if (radarSub) radarSub.textContent = t('off_duty_radar_sub');

    if (unitStatus) {
      unitStatus.className = 'text-xs font-bold text-amber-600 flex items-center gap-1.5';
      unitStatus.innerHTML = `<span class="w-2 h-2 rounded-full bg-amber-500"></span> ${t('paused_dispatch')}`;
    }
    if (profileBadge) {
      profileBadge.className = 'font-extrabold text-amber-400';
      profileBadge.textContent = t('off_duty_badge');
    }
  }

  if (window.lucide) {
    try { window.lucide.createIcons(); } catch (e) {}
  }
}

function initWaitingFlow() {
  const simulateBtn = document.getElementById('simulateDispatchBtn');
  const openProfileBtn = document.getElementById('openProfileBtn');
  const openHistoryBtn = document.getElementById('openHistoryBtn');
  const toggleDutyBtn = document.getElementById('toggleDutyModeBtn');
  const modalProfile = document.getElementById('modalProfile');
  const modalHistory = document.getElementById('modalHistory');

  if (toggleDutyBtn) {
    toggleDutyBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (AppState.driver.status === 'ON_DUTY') {
        AppState.driver.status = 'OFF_DUTY';
        AudioEngine.playAcknowledgeBeep();
        updateDutyModeUI();
      } else {
        AppState.driver.status = 'ON_DUTY';
        AudioEngine.playAcknowledgeBeep();
        updateDutyModeUI();
        showDutyStartedPopup('Arun Kumar', 'TN 01 AB 4521');
      }
    });
  }

  if (openProfileBtn && modalProfile) {
    openProfileBtn.addEventListener('click', (e) => {
      e.preventDefault();
      updateDutyModeUI();
      modalProfile.classList.remove('hidden');
    });
  }

  if (openHistoryBtn && modalHistory) {
    openHistoryBtn.addEventListener('click', (e) => {
      e.preventDefault();
      renderHistoryRecords();
      modalHistory.classList.remove('hidden');
    });
  }

  if (simulateBtn) {
    simulateBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (AppState.driver.status === 'OFF_DUTY') {
        // Auto resume duty if testing dispatch
        AppState.driver.status = 'ON_DUTY';
        updateDutyModeUI();
      }
      triggerEmergencyAssignment();
    });
  }
}

function triggerEmergencyAssignment() {
  const scenario = TEST_EMERGENCY_SCENARIOS[scenarioIndex % TEST_EMERGENCY_SCENARIOS.length];
  scenarioIndex++;

  const generatedId = `ER-2026-${Math.floor(10000 + Math.random() * 90000)}`;

  AppState.activeCase = {
    caseId: generatedId,
    caller: {
      name: 'Emergency Caller',
      phone: scenario.phone
    },
    location: {
      latitude: scenario.lat,
      longitude: scenario.lng,
      address: scenario.address
    },
    startLocation: {
      latitude: scenario.startLat,
      longitude: scenario.startLng
    },
    complaint: scenario.complaint,
    etaMinutes: scenario.eta,
    distanceKm: scenario.dist,
    incidentType: null,
    recommendedHospital: null,
    alternateHospital: null,
    hospitalRerouted: false,
    rerouteReason: null,
    timestamps: {
      dispatched: getFormattedTime(),
      accepted: null,
      incidentArrival: null,
      telemetryReceived: null,
      hospitalSelected: null,
      hospitalRerouted: null,
      hospitalArrival: null,
      patientHandover: null,
      caseClosed: null
    },
    status: 'RINGING'
  };

  const caseIdEl = document.getElementById('incomingCaseId');
  const addressEl = document.getElementById('incomingAddress');
  const distEl = document.getElementById('incomingDistance');
  const etaEl = document.getElementById('incomingEta');
  const severityEl = document.getElementById('incomingSeverity');

  if (caseIdEl) caseIdEl.textContent = AppState.activeCase.caseId;
  if (addressEl) addressEl.textContent = AppState.activeCase.location.address;
  if (distEl) distEl.textContent = `${AppState.activeCase.distanceKm} km`;
  if (etaEl) etaEl.textContent = `${AppState.activeCase.etaMinutes} min`;
  if (severityEl) severityEl.textContent = 'High Priority';

  resetSwipeControl();
  navigateToScreen('screenIncomingCall');
  AudioEngine.startEmergencySiren();
}

/* ==========================================================================
   5. Screen 4: Smartphone Call UI & "Slide to Attend" Controller
   ========================================================================== */
function initSwipeToAttend() {
  const track = document.getElementById('swipeTrack');
  const thumb = document.getElementById('swipeThumb');
  const progress = document.getElementById('swipeProgress');

  if (!track || !thumb || !progress) return;

  let isDragging = false;
  let startX = 0;
  let currentX = 0;
  let maxDrag = 0;

  function onStart(clientX) {
    isDragging = true;
    startX = clientX;
    maxDrag = (track.clientWidth || 300) - (thumb.clientWidth || 50) - 10;
  }

  function onMove(clientX) {
    if (!isDragging) return;
    const deltaX = clientX - startX;
    currentX = Math.max(0, Math.min(deltaX, maxDrag));
    
    thumb.style.transform = `translateX(${currentX}px)`;
    progress.style.width = `${currentX + 30}px`;

    if (currentX >= maxDrag * 0.80) {
      isDragging = false;
      onSwipeComplete();
    }
  }

  function onEnd() {
    if (!isDragging) return;
    isDragging = false;

    thumb.style.transition = 'transform 0.25s ease';
    progress.style.transition = 'width 0.25s ease';
    thumb.style.transform = 'translateX(0px)';
    progress.style.width = '0px';

    setTimeout(() => {
      thumb.style.transition = '';
      progress.style.transition = '';
    }, 250);
  }

  thumb.addEventListener('mousedown', (e) => onStart(e.clientX));
  window.addEventListener('mousemove', (e) => onMove(e.clientX));
  window.addEventListener('mouseup', onEnd);

  thumb.addEventListener('touchstart', (e) => {
    if (e.touches.length > 0) onStart(e.touches[0].clientX);
  }, { passive: true });

  window.addEventListener('touchmove', (e) => {
    if (e.touches.length > 0) onMove(e.touches[0].clientX);
  }, { passive: true });

  window.addEventListener('touchend', onEnd);

  thumb.addEventListener('click', (e) => {
    e.stopPropagation();
    onSwipeComplete();
  });
}

function resetSwipeControl() {
  const thumb = document.getElementById('swipeThumb');
  const progress = document.getElementById('swipeProgress');
  if (thumb) {
    thumb.style.transition = '';
    thumb.style.transform = 'translateX(0px)';
  }
  if (progress) {
    progress.style.transition = '';
    progress.style.width = '0px';
  }
}

function onSwipeComplete() {
  if (!AppState.activeCase) return;

  AudioEngine.stopEmergencySiren();
  AudioEngine.playAcknowledgeBeep();

  AppState.activeCase.status = 'NAVIGATING_TO_INCIDENT';
  AppState.activeCase.timestamps.accepted = getFormattedTime();

  const navCaseIdEl = document.getElementById('navCaseId');
  const navAddressEl = document.getElementById('navAddressTitle');
  const navCallerEl = document.getElementById('navCallerPhone');
  const navCallLink = document.getElementById('callCallerLink');
  const navEtaEl = document.getElementById('navEtaDisplay');
  const navDistEl = document.getElementById('navDistanceDisplay');
  const bottomDistEl = document.getElementById('bottomNavDistance');
  const bottomEtaEl = document.getElementById('bottomNavEta');

  if (navCaseIdEl) navCaseIdEl.textContent = AppState.activeCase.caseId;
  if (navAddressEl) navAddressEl.textContent = AppState.activeCase.location.address.split(',')[0];
  if (navCallerEl) navCallerEl.textContent = AppState.activeCase.caller.phone;
  if (navCallLink) navCallLink.href = `tel:${AppState.activeCase.caller.phone.replace(/\s+/g, '')}`;
  if (navEtaEl) navEtaEl.textContent = `${AppState.activeCase.etaMinutes} min`;
  if (navDistEl) navDistEl.textContent = `${AppState.activeCase.distanceKm} km remaining`;
  if (bottomDistEl) bottomDistEl.textContent = `${AppState.activeCase.distanceKm} km`;
  if (bottomEtaEl) bottomEtaEl.textContent = `${AppState.activeCase.etaMinutes} min`;

  navigateToScreen('screenNavigation');
}

/* ==========================================================================
   6. Screen 5: Navigation to Incident Location & Leaflet Map
   ========================================================================== */
function initOrUpdateMap() {
  const mapContainer = document.getElementById('navMap');
  if (!mapContainer || !window.L || !AppState.activeCase) return;

  const start = [AppState.activeCase.startLocation.latitude, AppState.activeCase.startLocation.longitude];
  const dest = [AppState.activeCase.location.latitude, AppState.activeCase.location.longitude];

  if (!AppState.map) {
    AppState.map = L.map('navMap', {
      zoomControl: false,
      attributionControl: false
    }).setView(start, 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(AppState.map);
  }

  if (AppState.mapMarkers.ambulance) AppState.map.removeLayer(AppState.mapMarkers.ambulance);
  if (AppState.mapMarkers.destination) AppState.map.removeLayer(AppState.mapMarkers.destination);
  if (AppState.mapMarkers.routeLine) AppState.map.removeLayer(AppState.mapMarkers.routeLine);

  const destIcon = L.divIcon({
    className: 'custom-dest-pin-marker',
    html: '<div class="dest-pin-ripple"></div><div class="dest-pin-core"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="3" fill="#ffffff"/></svg></div>',
    iconSize: [44, 44],
    iconAnchor: [22, 22]
  });

  const ambulanceIcon = L.divIcon({
    className: 'custom-amb-nav-marker',
    html: '<div class="amb-nav-halo"></div><div class="amb-nav-core"><svg width="18" height="18" viewBox="0 0 24 24" fill="#2563eb" stroke="#2563eb" stroke-width="2"><polygon points="12 2 19 21 12 17 5 21 12 2"/></svg></div>',
    iconSize: [44, 44],
    iconAnchor: [22, 22]
  });

  AppState.mapMarkers.destination = L.marker(dest, { icon: destIcon }).addTo(AppState.map);
  AppState.mapMarkers.ambulance = L.marker(start, { icon: ambulanceIcon }).addTo(AppState.map);

  const routePoints = [
    start,
    [13.0550, 80.2030],
    [13.0680, 80.2070],
    [13.0780, 80.2085],
    dest
  ];

  AppState.mapMarkers.routeLine = L.polyline(routePoints, {
    color: '#2563eb',
    weight: 6,
    opacity: 0.95,
    lineCap: 'round',
    lineJoin: 'round'
  }).addTo(AppState.map);

  AppState.map.fitBounds(AppState.mapMarkers.routeLine.getBounds(), { padding: [40, 40] });
}

function initNavigationFlow() {
  const markArrivedBtn = document.getElementById('markArrivedBtn');
  const recenterMapBtn = document.getElementById('recenterMapBtn');
  const simulateDriveBtn = document.getElementById('simulateDriveProgressBtn');

  if (recenterMapBtn) {
    recenterMapBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (AppState.map && AppState.mapMarkers.routeLine) {
        AppState.map.fitBounds(AppState.mapMarkers.routeLine.getBounds(), { padding: [40, 40] });
        AudioEngine.playAcknowledgeBeep();
      }
    });
  }

  if (simulateDriveBtn) {
    simulateDriveBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (!AppState.activeCase) return;

      let eta = AppState.activeCase.etaMinutes;
      let dist = AppState.activeCase.distanceKm;

      if (eta > 1) {
        eta = Math.max(1, eta - 4);
        dist = Math.max(0.4, (dist - 1.5)).toFixed(1);
        AppState.activeCase.etaMinutes = eta;
        AppState.activeCase.distanceKm = dist;

        const navEtaEl = document.getElementById('navEtaDisplay');
        const navDistEl = document.getElementById('navDistanceDisplay');
        const bottomDistEl = document.getElementById('bottomNavDistance');
        const bottomEtaEl = document.getElementById('bottomNavEta');

        if (navEtaEl) navEtaEl.textContent = `${eta} min`;
        if (navDistEl) navDistEl.textContent = `${dist} km remaining`;
        if (bottomDistEl) bottomDistEl.textContent = `${dist} km`;
        if (bottomEtaEl) bottomEtaEl.textContent = `${eta} min`;

        if (AppState.mapMarkers.ambulance) {
          AppState.mapMarkers.ambulance.setLatLng([13.0780, 80.2085]);
        }
        AudioEngine.playAcknowledgeBeep();
      }
    });
  }

  if (markArrivedBtn) {
    markArrivedBtn.addEventListener('click', (e) => {
      e.preventDefault();
      markArrivedAtIncidentLocation();
    });
  }
}

/* ==========================================================================
   7. Screen 6: Arrived at Incident Location & Medical Report -> Slide to Start Trip
   ========================================================================== */
function markArrivedAtIncidentLocation() {
  if (!AppState.activeCase) return;

  AppState.activeCase.status = 'ARRIVED_AT_INCIDENT';
  AppState.activeCase.timestamps.incidentArrival = getFormattedTime();

  // Automatic backend evaluation of medical issue & hospital recommendation
  const incidentType = AppState.activeCase.incidentType || 'CARDIAC_EMERGENCY';
  AppState.activeCase.incidentType = incidentType;
  AppState.activeCase.timestamps.telemetryReceived = getFormattedTime();

  const rankingResult = HospitalRankingEngine.evaluate(incidentType, AppState.activeCase.location);
  AppState.activeCase.recommendedHospital = rankingResult.primary;
  AppState.activeCase.alternateHospital = rankingResult.alternate;
  AppState.activeCase.timestamps.hospitalSelected = getFormattedTime();

  const caseIdEl = document.getElementById('incidentArrivedCaseId');
  const addressEl = document.getElementById('incidentArrivedAddress');
  const reportTypeEl = document.getElementById('reportIncidentType');
  const reportHospEl = document.getElementById('reportHospitalName');
  const reportDistEl = document.getElementById('reportHospitalDistance');
  const reportEtaEl = document.getElementById('reportHospitalEta');

  const config = MEDICAL_INCIDENT_TYPES[incidentType] || MEDICAL_INCIDENT_TYPES.CARDIAC_EMERGENCY;
  if (caseIdEl) caseIdEl.textContent = AppState.activeCase.caseId;
  if (addressEl) addressEl.textContent = AppState.activeCase.location.address;
  if (reportTypeEl) reportTypeEl.textContent = config.label.toUpperCase();
  if (reportHospEl) reportHospEl.textContent = rankingResult.primary.name;
  if (reportDistEl) reportDistEl.innerHTML = `Distance: <strong>${rankingResult.primary.distanceKm} km</strong>`;
  if (reportEtaEl) reportEtaEl.textContent = `ETA: ${rankingResult.primary.etaMinutes} min`;

  resetSlideStartTrip();
  AudioEngine.playArrivalChime();
  navigateToScreen('screenArrivedIncident');
}

function initSlideStartTrip() {
  const track = document.getElementById('slideStartTripTrack');
  const thumb = document.getElementById('slideStartTripThumb');
  const progress = document.getElementById('slideStartTripProgress');

  if (!track || !thumb || !progress) return;

  let isDragging = false;
  let startX = 0;
  let currentX = 0;
  let maxDrag = 0;

  function onStart(clientX) {
    isDragging = true;
    startX = clientX;
    maxDrag = (track.clientWidth || 300) - (thumb.clientWidth || 50) - 10;
  }

  function onMove(clientX) {
    if (!isDragging) return;
    const deltaX = clientX - startX;
    currentX = Math.max(0, Math.min(deltaX, maxDrag));
    
    thumb.style.transform = `translateX(${currentX}px)`;
    progress.style.width = `${currentX + 30}px`;

    if (currentX >= maxDrag * 0.80) {
      isDragging = false;
      startHospitalNavigation();
    }
  }

  function onEnd() {
    if (!isDragging) return;
    isDragging = false;

    thumb.style.transition = 'transform 0.25s ease';
    progress.style.transition = 'width 0.25s ease';
    thumb.style.transform = 'translateX(0px)';
    progress.style.width = '0px';

    setTimeout(() => {
      thumb.style.transition = '';
      progress.style.transition = '';
    }, 250);
  }

  thumb.addEventListener('mousedown', (e) => onStart(e.clientX));
  window.addEventListener('mousemove', (e) => onMove(e.clientX));
  window.addEventListener('mouseup', onEnd);

  thumb.addEventListener('touchstart', (e) => {
    if (e.touches.length > 0) onStart(e.touches[0].clientX);
  }, { passive: true });

  window.addEventListener('touchmove', (e) => {
    if (e.touches.length > 0) onMove(e.touches[0].clientX);
  }, { passive: true });

  window.addEventListener('touchend', onEnd);

  thumb.addEventListener('click', (e) => {
    e.stopPropagation();
    startHospitalNavigation();
  });
}

function resetSlideStartTrip() {
  const thumb = document.getElementById('slideStartTripThumb');
  const progress = document.getElementById('slideStartTripProgress');
  if (thumb) {
    thumb.style.transition = '';
    thumb.style.transform = 'translateX(0px)';
  }
  if (progress) {
    progress.style.transition = '';
    progress.style.width = '0px';
  }
}

/* ==========================================================================
   8. Screen 8: Active Hospital Navigation & Dynamic Availability Monitoring
   ========================================================================== */
function startHospitalNavigation() {
  if (!AppState.activeCase || !AppState.activeCase.recommendedHospital) return;

  AppState.activeCase.status = 'NAVIGATING_TO_HOSPITAL';
  AudioEngine.playAcknowledgeBeep();

  const hosp = AppState.activeCase.recommendedHospital;
  const caseIdEl = document.getElementById('hospNavCaseId');
  const titleEl = document.getElementById('hospNavTitle');
  const etaEl = document.getElementById('hospNavEtaDisplay');
  const distEl = document.getElementById('hospNavDistanceDisplay');
  const bottomNameEl = document.getElementById('bottomHospName');
  const bottomDistEl = document.getElementById('bottomHospDistance');
  const bottomEtaEl = document.getElementById('bottomHospEta');
  const callLink = document.getElementById('callHospitalLink');

  if (caseIdEl) caseIdEl.textContent = AppState.activeCase.caseId;
  if (titleEl) titleEl.textContent = hosp.shortName;
  if (etaEl) etaEl.textContent = `${hosp.etaMinutes} min`;
  if (distEl) distEl.textContent = `${hosp.distanceKm} km remaining`;
  if (bottomNameEl) bottomNameEl.textContent = hosp.name;
  if (bottomDistEl) bottomDistEl.textContent = `${hosp.distanceKm} km`;
  if (bottomEtaEl) bottomEtaEl.textContent = `${hosp.etaMinutes} min`;
  if (callLink) callLink.href = `tel:${hosp.phone.replace(/\s+/g, '')}`;

  const banner = document.getElementById('hospitalRerouteBanner');
  if (banner) banner.classList.add('hidden');

  navigateToScreen('screenHospitalNavigation');
}

function initOrUpdateHospitalMap() {
  const mapContainer = document.getElementById('hospitalNavMap');
  if (!mapContainer || !window.L || !AppState.activeCase || !AppState.activeCase.recommendedHospital) return;

  const start = [AppState.activeCase.location.latitude, AppState.activeCase.location.longitude];
  const hosp = AppState.activeCase.recommendedHospital;
  const dest = [hosp.lat, hosp.lng];

  if (!AppState.hospitalMap) {
    AppState.hospitalMap = L.map('hospitalNavMap', {
      zoomControl: false,
      attributionControl: false
    }).setView(start, 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(AppState.hospitalMap);
  }

  if (AppState.hospitalMapMarkers.ambulance) AppState.hospitalMap.removeLayer(AppState.hospitalMapMarkers.ambulance);
  if (AppState.hospitalMapMarkers.destination) AppState.hospitalMap.removeLayer(AppState.hospitalMapMarkers.destination);
  if (AppState.hospitalMapMarkers.routeLine) AppState.hospitalMap.removeLayer(AppState.hospitalMapMarkers.routeLine);

  const hospIcon = L.divIcon({
    className: 'custom-hospital-pin-marker',
    html: '<div class="hospital-pin-ripple"></div><div class="hospital-pin-core"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 6v12M6 12h12"/></svg></div>',
    iconSize: [46, 46],
    iconAnchor: [23, 23]
  });

  const ambulanceIcon = L.divIcon({
    className: 'custom-amb-nav-marker',
    html: '<div class="amb-nav-halo"></div><div class="amb-nav-core"><svg width="18" height="18" viewBox="0 0 24 24" fill="#0284c7" stroke="#0284c7" stroke-width="2"><polygon points="12 2 19 21 12 17 5 21 12 2"/></svg></div>',
    iconSize: [44, 44],
    iconAnchor: [22, 22]
  });

  AppState.hospitalMapMarkers.destination = L.marker(dest, { icon: hospIcon }).addTo(AppState.hospitalMap);
  AppState.hospitalMapMarkers.ambulance = L.marker(start, { icon: ambulanceIcon }).addTo(AppState.hospitalMap);

  const routePoints = [
    start,
    [start[0] + 0.015, start[1] + 0.010],
    [start[0] + 0.035, start[1] + 0.025],
    [dest[0] - 0.010, dest[1] - 0.010],
    dest
  ];

  AppState.hospitalMapMarkers.routeLine = L.polyline(routePoints, {
    color: '#0284c7',
    weight: 6,
    opacity: 0.95,
    lineCap: 'round',
    lineJoin: 'round'
  }).addTo(AppState.hospitalMap);

  AppState.hospitalMap.fitBounds(AppState.hospitalMapMarkers.routeLine.getBounds(), { padding: [40, 40] });
}

function initHospitalNavigationFlow() {
  const markHospArrivedBtn = document.getElementById('markHospArrivedBtn');
  const recenterBtn = document.getElementById('recenterHospMapBtn');
  const simulateDriveBtn = document.getElementById('simulateHospDriveProgressBtn');
  const simulateRerouteBtn = document.getElementById('simulateHospInavailabilityBtn');
  const ackRerouteBtn = document.getElementById('ackRerouteBtn');

  if (recenterBtn) {
    recenterBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (AppState.hospitalMap && AppState.hospitalMapMarkers.routeLine) {
        AppState.hospitalMap.fitBounds(AppState.hospitalMapMarkers.routeLine.getBounds(), { padding: [40, 40] });
        AudioEngine.playAcknowledgeBeep();
      }
    });
  }

  if (simulateDriveBtn) {
    simulateDriveBtn.addEventListener('click', (e) => {
      e.preventDefault();
      if (!AppState.activeCase || !AppState.activeCase.recommendedHospital) return;

      let eta = AppState.activeCase.recommendedHospital.etaMinutes;
      let dist = AppState.activeCase.recommendedHospital.distanceKm;

      if (eta > 1) {
        eta = Math.max(1, eta - 4);
        dist = Math.max(0.4, (dist - 1.8)).toFixed(1);
        AppState.activeCase.recommendedHospital.etaMinutes = eta;
        AppState.activeCase.recommendedHospital.distanceKm = dist;

        const etaEl = document.getElementById('hospNavEtaDisplay');
        const distEl = document.getElementById('hospNavDistanceDisplay');
        const bottomDistEl = document.getElementById('bottomHospDistance');
        const bottomEtaEl = document.getElementById('bottomHospEta');

        if (etaEl) etaEl.textContent = `${eta} min`;
        if (distEl) distEl.textContent = `${dist} km remaining`;
        if (bottomDistEl) bottomDistEl.textContent = `${dist} km`;
        if (bottomEtaEl) bottomEtaEl.textContent = `${eta} min`;

        AudioEngine.playAcknowledgeBeep();
      }
    });
  }

  if (simulateRerouteBtn) {
    simulateRerouteBtn.addEventListener('click', (e) => {
      e.preventDefault();
      triggerDynamicHospitalReroute('ICU bed availability changed at primary hospital');
    });
  }

  if (ackRerouteBtn) {
    ackRerouteBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const banner = document.getElementById('hospitalRerouteBanner');
      if (banner) banner.classList.add('hidden');
      AudioEngine.playAcknowledgeBeep();
    });
  }

  if (markHospArrivedBtn) {
    markHospArrivedBtn.addEventListener('click', (e) => {
      e.preventDefault();
      completeTripAndShowReport();
    });
  }
}

/* ==========================================================================
   10. Dynamic Hospital Availability Monitoring & Route Recalculation
   ========================================================================== */
function triggerDynamicHospitalReroute(reason) {
  if (!AppState.activeCase || !AppState.activeCase.alternateHospital) return;

  const previousHospital = AppState.activeCase.recommendedHospital;
  const newHospital = AppState.activeCase.alternateHospital;

  AppState.activeCase.hospitalRerouted = true;
  AppState.activeCase.primaryHospital = previousHospital.name;
  AppState.activeCase.recommendedHospital = newHospital;
  AppState.activeCase.rerouteReason = reason;
  AppState.activeCase.timestamps.hospitalRerouted = getFormattedTime();

  AudioEngine.playAlertChime();

  // Show emergency reroute banner
  const banner = document.getElementById('hospitalRerouteBanner');
  const reasonText = document.getElementById('rerouteReasonText');
  if (banner) banner.classList.remove('hidden');
  if (reasonText) {
    if (AppState.currentLanguage === 'ta') {
      reasonText.innerHTML = `${previousHospital.shortName}-ல் ICU பெட் இல்லை. மாற்றப்பட்ட ஆஸ்பத்திரி: <strong class="text-white font-bold">${newHospital.shortName}</strong> (${newHospital.distanceKm} கி.மீ • ${newHospital.etaMinutes} நிமிடம்)`;
    } else {
      reasonText.innerHTML = `${previousHospital.shortName} ICU unavailable. Routing to: <strong class="text-white font-bold">${newHospital.shortName}</strong> (${newHospital.distanceKm} km • ${newHospital.etaMinutes} min)`;
    }
  }

  // Update HUD & Bottom Drawer
  const titleEl = document.getElementById('hospNavTitle');
  const etaEl = document.getElementById('hospNavEtaDisplay');
  const distEl = document.getElementById('hospNavDistanceDisplay');
  const bottomNameEl = document.getElementById('bottomHospName');
  const bottomDistEl = document.getElementById('bottomHospDistance');
  const bottomEtaEl = document.getElementById('bottomHospEta');
  const callLink = document.getElementById('callHospitalLink');

  if (titleEl) titleEl.textContent = newHospital.shortName;
  if (etaEl) etaEl.textContent = `${newHospital.etaMinutes} min`;
  if (distEl) distEl.textContent = `${newHospital.distanceKm} km remaining`;
  if (bottomNameEl) bottomNameEl.textContent = newHospital.name;
  if (bottomDistEl) bottomDistEl.textContent = `${newHospital.distanceKm} km`;
  if (bottomEtaEl) bottomEtaEl.textContent = `${newHospital.etaMinutes} min`;
  if (callLink) callLink.href = `tel:${newHospital.phone.replace(/\s+/g, '')}`;

  // Recalculate route and redraw map
  initOrUpdateHospitalMap();
}

/* ==========================================================================
   11. Trip Completion & 1-Page Trip Report
   ========================================================================== */
function completeTripAndShowReport() {
  if (!AppState.activeCase) return;

  const c = AppState.activeCase;
  const hosp = c.recommendedHospital || CHENNAI_HOSPITALS[0];
  const typeConfig = MEDICAL_INCIDENT_TYPES[c.incidentType] || MEDICAL_INCIDENT_TYPES.CARDIAC_EMERGENCY;

  c.status = 'COMPLETED';
  c.timestamps.hospitalArrival = getFormattedTime();
  c.timestamps.patientHandover = getFormattedTime();
  c.timestamps.caseClosed = getFormattedTime();

  const totalDist = (c.distanceKm + hosp.distanceKm).toFixed(1);
  const totalDur = (c.etaMinutes + hosp.etaMinutes + 6);

  // Add completed record to history store
  AppState.history.unshift({
    caseId: c.caseId,
    incidentType: c.incidentType || 'CARDIAC_EMERGENCY',
    incidentLocation: c.location.address,
    hospital: hosp.name,
    primaryHospital: c.primaryHospital || hosp.name,
    hospitalChanged: c.hospitalRerouted,
    rerouteReason: c.rerouteReason,
    totalDistance: `${totalDist} km`,
    totalDuration: `${totalDur} min`,
    date: 'Today',
    time: c.timestamps.dispatched,
    status: 'COMPLETED'
  });

  // Populate Trip Report page
  const caseIdEl = document.getElementById('completedCaseId');
  const typeEl = document.getElementById('reportSummaryType');
  const pickupEl = document.getElementById('reportSummaryPickup');
  const hospEl = document.getElementById('reportSummaryHospital');
  const distEl = document.getElementById('reportSummaryDistance');
  const durEl = document.getElementById('reportSummaryDuration');

  if (caseIdEl) caseIdEl.textContent = `CASE ID: ${c.caseId}`;
  if (typeEl) typeEl.textContent = (t(c.incidentType) || typeConfig.label).toUpperCase();
  if (pickupEl) pickupEl.textContent = c.location.address;
  if (hospEl) hospEl.textContent = hosp.name;
  if (distEl) distEl.textContent = `${totalDist} km`;
  if (durEl) durEl.textContent = `${totalDur} min`;

  AudioEngine.playArrivalChime();
  navigateToScreen('screenCompleted');
}

function initCompletedFlow() {
  const backToDutyBtn = document.getElementById('backToDutyBtn');
  if (backToDutyBtn) {
    backToDutyBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const closedCaseId = AppState.activeCase ? AppState.activeCase.caseId : 'ER-2026-69655';
      AppState.activeCase = null;
      AppState.driver.status = 'ON_DUTY';
      AudioEngine.playAcknowledgeBeep();
      navigateToScreen('screenWaiting');
      showCaseClosedPopup(closedCaseId);
    });
  }
}

/* ==========================================================================
   12. Case Closed Popup Notification
   ========================================================================== */
function showCaseClosedPopup(closedCaseId) {
  const popup = document.getElementById('caseClosedPopup');
  const title = document.getElementById('caseClosedPopupTitle');
  const status = document.getElementById('caseClosedPopupStatus');
  const sub = document.getElementById('caseClosedPopupSub');
  const closeBtn = document.getElementById('closeCaseClosedPopupBtn');

  if (!popup) return;
  if (title) title.textContent = t('case_closed_title');
  if (status) status.textContent = t('case_closed_status');
  if (sub) {
    if (AppState.currentLanguage === 'ta') {
      sub.textContent = `கேஸ் ${closedCaseId} வெற்றிகரமாக முடிந்தது. அடுத்த எமர்ஜென்சிக்கு தயார்.`;
    } else {
      sub.textContent = `Case ${closedCaseId} closed successfully. Unit ready on duty.`;
    }
  }

  popup.classList.add('show');
  const hidePopup = () => popup.classList.remove('show');
  if (closeBtn) closeBtn.onclick = hidePopup;
  setTimeout(hidePopup, 4000);
}

/* ==========================================================================
   13. History Records Renderer
   ========================================================================== */
function renderHistoryRecords() {
  const container = document.getElementById('historyRecordsList');
  if (!container) return;

  if (AppState.history.length === 0) {
    container.innerHTML = `
      <div class="p-6 text-center text-slate-400 text-xs">
        <i data-lucide="inbox" class="w-8 h-8 mx-auto mb-2 opacity-50"></i>
        <p>${AppState.currentLanguage === 'ta' ? 'இன்றைய பணியில் பதிவுகள் எதுவும் இல்லை.' : 'No response records recorded for current shift.'}</p>
      </div>
    `;
    if (window.lucide) {
      try { window.lucide.createIcons(); } catch (e) {}
    }
    return;
  }

  container.innerHTML = AppState.history.map(item => {
    const config = MEDICAL_INCIDENT_TYPES[item.incidentType] || MEDICAL_INCIDENT_TYPES.CARDIAC_EMERGENCY;
    const categoryLabel = t(item.incidentType) || config.label;
    const dateLabel = item.date === 'Today' ? t('today') : item.date;
    const statusLabel = item.status === 'COMPLETED' ? (AppState.currentLanguage === 'ta' ? 'முடிந்தது' : 'COMPLETED') : item.status;

    return `
      <div class="p-3.5 rounded-2xl bg-slate-800/90 border border-slate-700 space-y-2 hover:border-slate-600 transition-colors shadow-md text-white">
        <div class="flex items-center justify-between">
          <span class="text-xs font-mono font-black text-white">${item.caseId}</span>
          <span class="text-[9.5px] font-extrabold px-2.5 py-0.5 rounded-full bg-emerald-950 text-emerald-400 border border-emerald-700 flex items-center gap-1">
            <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span> ${statusLabel}
          </span>
        </div>

        <div class="inline-flex items-center gap-1.5 text-[11px] font-black text-rose-400">
          <i data-lucide="${config.icon}" class="w-3.5 h-3.5"></i>
          <span>${categoryLabel.toUpperCase()}</span>
        </div>

        <div class="space-y-1.5 text-xs">
          <div class="flex items-start gap-2 text-slate-300">
            <i data-lucide="map-pin" class="w-3.5 h-3.5 text-rose-400 mt-0.5 shrink-0"></i>
            <span class="font-bold leading-tight text-white">${item.incidentLocation}</span>
          </div>

          <div class="flex items-start gap-2 text-slate-300 pt-0.5">
            <i data-lucide="building-2" class="w-3.5 h-3.5 text-sky-400 mt-0.5 shrink-0"></i>
            <span class="font-medium leading-tight text-slate-200">${item.hospital}</span>
          </div>

          ${item.hospitalChanged ? `
            <div class="p-2 rounded-xl bg-amber-950/80 border border-amber-700/80 text-[10.5px] text-amber-300 font-medium space-y-0.5">
              <span class="font-bold flex items-center gap-1 text-amber-400">
                <i data-lucide="alert-triangle" class="w-3 h-3 text-amber-400"></i> ${t('primary_hosp_rerouted')}
              </span>
              <p class="text-slate-300">${item.rerouteReason || 'ICU availability changed'}</p>
            </div>
          ` : ''}

          <div class="flex items-center justify-between text-[11px] text-slate-400 border-t border-slate-700/70 pt-1.5 font-mono">
            <span class="text-slate-400">🕒 ${dateLabel} • ${item.time}</span>
            <span class="text-emerald-400 font-bold">⏱ ${item.totalDistance} • ${item.totalDuration}</span>
          </div>
        </div>
      </div>
    `;
  }).join('');

  if (window.lucide) {
    try { window.lucide.createIcons(); } catch (e) {}
  }
}

/* ==========================================================================
   14. Modals & Accidental Logout Guard
   ========================================================================== */
function initModals() {
  const modalProfile = document.getElementById('modalProfile');
  const modalActiveGuard = document.getElementById('modalActiveGuard');
  const modalSupport = document.getElementById('modalSupport');
  const modalHistory = document.getElementById('modalHistory');

  const closeProfile = document.getElementById('closeProfileModalBtn');
  const closeSupport = document.getElementById('closeSupportModalBtn');
  const dismissGuard = document.getElementById('dismissGuardModalBtn');
  const closeHistoryModalBtn = document.getElementById('closeHistoryModalBtn');
  const closeHistoryBottomBtn = document.getElementById('closeHistoryBottomBtn');
  const endDutyBtn = document.getElementById('endDutyBtn');

  const langBtnEn = document.getElementById('langBtnEn');
  const langBtnTa = document.getElementById('langBtnTa');
  const sirenSelect = document.getElementById('sirenSoundSelect');
  const testSirenBtn = document.getElementById('testSirenBtn');
  const currentSirenBadge = document.getElementById('currentSirenBadge');
  const testSirenIcon = document.getElementById('testSirenIcon');
  const testSirenText = document.getElementById('testSirenText');

  const updateSirenBadge = (tone) => {
    if (!currentSirenBadge) return;
    const badgeNames = {
      yelp: '⚡ RAPID YELP',
      q2b: '🚨 THE BEAST Q2B',
      rumbler: '💥 THE RUMBLER',
      airhorn: '📢 AIR HORN',
      hilo: '🚨 CLASSIC HI-LO',
      buzzer: '📟 DIGITAL BUZZER'
    };
    currentSirenBadge.textContent = badgeNames[tone] || '⚡ RAPID YELP';
  };

  if (sirenSelect) {
    sirenSelect.value = AppState.sirenTone || 'yelp';
    updateSirenBadge(sirenSelect.value);

    sirenSelect.addEventListener('change', (e) => {
      AppState.sirenTone = e.target.value;
      try {
        localStorage.setItem('ambulance_siren_tone', AppState.sirenTone);
      } catch (err) {}
      updateSirenBadge(AppState.sirenTone);
      AudioEngine.playAcknowledgeBeep();
    });
  }

  if (testSirenBtn) {
    testSirenBtn.addEventListener('click', () => {
      if (AudioEngine.isPlayingSiren) {
        AudioEngine.stopEmergencySiren();
        if (testSirenIcon) testSirenIcon.textContent = '▶';
        if (testSirenText) testSirenText.textContent = 'Test';
      } else {
        if (testSirenIcon) testSirenIcon.textContent = '⏹';
        if (testSirenText) testSirenText.textContent = 'Stop';
        AudioEngine.previewSirenTone(AppState.sirenTone || 'yelp');
        
        setTimeout(() => {
          if (testSirenIcon) testSirenIcon.textContent = '▶';
          if (testSirenText) testSirenText.textContent = 'Test';
        }, 3300);
      }
    });
  }

  if (langBtnEn) {
    langBtnEn.onclick = () => setLanguage('en');
  }
  if (langBtnTa) {
    langBtnTa.onclick = () => setLanguage('ta');
  }

  if (closeProfile) {
    closeProfile.onclick = () => {
      AudioEngine.stopEmergencySiren();
      if (testSirenIcon) testSirenIcon.textContent = '▶';
      if (testSirenText) testSirenText.textContent = 'Test';
      if (modalProfile) modalProfile.classList.add('hidden');
    };
  }
  if (closeSupport) closeSupport.onclick = () => modalSupport && modalSupport.classList.add('hidden');
  if (dismissGuard) dismissGuard.onclick = () => modalActiveGuard && modalActiveGuard.classList.add('hidden');

  if (closeHistoryModalBtn) closeHistoryModalBtn.onclick = () => modalHistory && modalHistory.classList.add('hidden');
  if (closeHistoryBottomBtn) closeHistoryBottomBtn.onclick = () => modalHistory && modalHistory.classList.add('hidden');

  if (endDutyBtn) {
    endDutyBtn.onclick = (e) => {
      e.preventDefault();
      if (modalProfile) modalProfile.classList.add('hidden');

      if (AppState.activeCase && AppState.activeCase.status !== 'CASE_COMPLETED') {
        if (modalActiveGuard) modalActiveGuard.classList.remove('hidden');
        return;
      }

      AppState.driver.status = 'OFF_DUTY';
      AppState.activeCase = null;
      AudioEngine.playAcknowledgeBeep();
      navigateToScreen('screenLogin');
    };
  }
}

/* ==========================================================================
   15. Immediate Application Bootstrapper
   ========================================================================== */
function initializeApp() {
  if (window.lucide) {
    try { window.lucide.createIcons(); } catch (e) {}
  }

  initClock();
  initLoginFlow();
  initWaitingFlow();
  initSwipeToAttend();
  initNavigationFlow();
  initSlideStartTrip();
  initHospitalNavigationFlow();
  initCompletedFlow();
  initModals();
  applyLanguage();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeApp);
} else {
  initializeApp();
}

// Expose key API to window for testing, automated verification and workflow control
window.AppState = AppState;
window.navigateToScreen = navigateToScreen;
window.triggerEmergencyAssignment = triggerEmergencyAssignment;
window.onSwipeComplete = onSwipeComplete;
window.arrivedAtIncidentLocation = arrivedAtIncidentLocation;
window.startHospitalNavigation = startHospitalNavigation;
window.triggerDynamicHospitalReroute = triggerDynamicHospitalReroute;
window.completeTripAndShowReport = completeTripAndShowReport;
window.showDutyStartedPopup = showDutyStartedPopup;
window.showCaseClosedPopup = showCaseClosedPopup;
window.setLanguage = setLanguage;
window.applyLanguage = applyLanguage;
window.renderHistoryRecords = renderHistoryRecords;

