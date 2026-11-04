from ..schemas.prediction_schema import ConsultationMessageRequest, ConsultationMessageResponse

def evaluate_cattle_symptoms(req: ConsultationMessageRequest) -> ConsultationMessageResponse:
    symptoms_text = " ".join(req.symptoms).lower() + " " + req.description.lower()

    if any(k in symptoms_text for k in ["liur", "luka kuku", "pincang", "lepuh", "pmk"]):
        return ConsultationMessageResponse(
            possible_diagnosis="Kecurigaan Penyakit Mulut dan Kuku (PMK) / Foot and Mouth Disease",
            urgency_level="DARURAT TINGGI (Segera Isolasi)",
            first_aid_action="Pisahkan sapi dari koloni. Cuci luka kuku dan mulut dengan larutan asam sitrat/desinfektan ringan. Berikan pakan lunak dan air gula aren.",
            nutritional_advice="Berikan pakan bubur konsentrat berenergi tinggi karena sapi mengalami nyeri mengunyah.",
            veterinary_contact="Puskeswan / Dinas Peternakan Kabupaten (Madura): (031) 309-xxxx",
        )
    elif any(k in symptoms_text for k in ["kembung", "buncit kiri", "sesak", "bloat", "timpani"]):
        return ConsultationMessageResponse(
            possible_diagnosis="Timpani Rumen Akut / Kembung Gas (Bloat)",
            urgency_level="DARURAT SEDANG - TINGGI",
            first_aid_action="Posisikan tubuh bagian depan lebih tinggi. Cekok dengan 300-500 ml minyak kelapa atau minyak goreng untuk memecah busa gas di rumen.",
            nutritional_advice="Hentikan sementara hijauan basah berembun atau leguminosa berlebihan. Berikan jerami kering.",
            veterinary_contact="Dokter Hewan Jaga Feedlot: Hubungi segera jika kembung tidak mereda dalam 2 jam.",
        )
    elif any(k in symptoms_text for k in ["kurus", "bulu berdiri", "kusam", "diare", "cacing"]):
        return ConsultationMessageResponse(
            possible_diagnosis="Helminthiasis (Cacingan Saluran Cerna / Hati)",
            urgency_level="RUTIN / TERENCANA",
            first_aid_action="Berikan anthelmintik spektrum luas (Albendazole 10% atau injeksi Ivermectin) sesuai takaran bobot sapi.",
            nutritional_advice="Tingkatkan pakan bernutrisi tinggi dan tambahkan premix mineral untuk memperbaiki kerusakan sel usus.",
            veterinary_contact="Mantri Ternak Desa terdekat untuk jadwal pengobatan berkala 3 bulan sekali.",
        )
    else:
        return ConsultationMessageResponse(
            possible_diagnosis="Penurunan Nafsu Makan / Gangguan Metabolisme Ringan",
            urgency_level="RINGAN / MONITORING",
            first_aid_action="Cek suhu rektal sapi. Berikan suntikan vitamin B-Complex dan pastikan ketersediaan air minum bersih tanpa batas (ad libitum).",
            nutritional_advice="Campurkan molase (tetes tebu) pada konsentrat untuk memancing nafsu makan (palatabilitas).",
            veterinary_contact="Konsultasi Dinas Peternakan / Asosiasi Peternak Sapi Madura.",
        )

