/*!
 * @brief	シンプルなモデルシェーダー。
 */


////////////////////////////////////////////////
// 定数バッファ。
////////////////////////////////////////////////
//モデル用の定数バッファ
cbuffer ModelCb : register(b0){
	float4x4 mWorld;
	float4x4 mView;
	float4x4 mProj;
};

//ライトの定数バッファ。
cbuffer LightDataCb : register(b1) {
	//ライトの色。
	float3 lightColor;
	//ライトの方向
	float3 lightDirection;
	//カメラの座標
	float3 eyePos;
}


////////////////////////////////////////////////
// 構造体
////////////////////////////////////////////////
//スキニング用の頂点データをひとまとめ。
struct SSkinVSIn{
	int4  Indices  	: BLENDINDICES0;
    float4 Weights  : BLENDWEIGHT0;
};
//頂点シェーダーへの入力。
struct SVSIn{
	float4 pos 		: POSITION;		//モデルの頂点座標。
	float2 uv 		: TEXCOORD0;	//UV座標。
	float3 normal	: NORMAL;
	SSkinVSIn skinVert;				//スキン用のデータ。
};
//ピクセルシェーダーへの入力。
struct SPSIn{
	float4 pos 			: SV_POSITION;	//スクリーン空間でのピクセルの座標。
	float2 uv 			: TEXCOORD0;	//uv座標。
	float3 normal	: NORMAL;
	float3 worldPos : TEXCOORD1;		//ワールド座標
};

////////////////////////////////////////////////
// グローバル変数。
////////////////////////////////////////////////
Texture2D<float4> g_albedo : register(t0);				//アルベドマップ
StructuredBuffer<float4x4> g_boneMatrix : register(t3);	//ボーン行列。
sampler g_sampler : register(s0);	//サンプラステート。

////////////////////////////////////////////////
// 関数定義。
////////////////////////////////////////////////

/// <summary>
//スキン行列を計算する。
/// </summary>
float4x4 CalcSkinMatrix(SSkinVSIn skinVert)
{
	float4x4 skinning = 0;	
	float w = 0.0f;
	[unroll]
    for (int i = 0; i < 3; i++)
    {
        skinning += g_boneMatrix[skinVert.Indices[i]] * skinVert.Weights[i];
        w += skinVert.Weights[i];
    }
    
    skinning += g_boneMatrix[skinVert.Indices[3]] * (1.0f - w);
	
    return skinning;
}

/// <summary>
/// 頂点シェーダーのコア関数。
/// </summary>
SPSIn VSMainCore(SVSIn vsIn, uniform bool hasSkin)
{
	SPSIn psIn;
	float4x4 m;
	if( hasSkin ){
		m = CalcSkinMatrix(vsIn.skinVert);
	}else{
		m = mWorld;
	}
	psIn.pos = mul(m, vsIn.pos);
	psIn.worldPos = psIn.pos;
	psIn.normal = mul(m, vsIn.normal);
	psIn.pos = mul(mView, psIn.pos);
	psIn.pos = mul(mProj, psIn.pos);

	psIn.uv = vsIn.uv;

	return psIn;
}

/// <summary>
/// スキンなしメッシュ用の頂点シェーダーのエントリー関数。
/// </summary>
SPSIn VSMain(SVSIn vsIn)
{
	return VSMainCore(vsIn, false);
}
/// <summary>
/// スキンありメッシュの頂点シェーダーのエントリー関数。
/// </summary>
SPSIn VSSkinMain( SVSIn vsIn ) 
{
	return VSMainCore(vsIn, true);
}
/// <summary>
/// ピクセルシェーダーのエントリー関数。
/// </summary>
float4 PSMain( SPSIn psIn ) : SV_Target0
{

	//テクスチャから色をサンプリング。
	float4 albedoColor = g_albedo.Sample(g_sampler, psIn.uv);

	//拡散反射光を計算。
	float t = dot(psIn.normal, lightDirection);
	if (t < 0.0f)
	{
		t = 0.0f;
	}
	float3 lig = lightColor * t;

	//鏡面反射光を計算。
	float3 refVec = reflect(lightDirection, psIn.normal);
	float3 toEye = eyePos - psIn.worldPos;
	toEye = normalize(toEye);
	 t = dot(refVec, toEye);
	if (t < 0.0f)
	{
		t = 0.0f;
	}
	t = pow(t, 5.0f);
	float3 specular = lightColor * t;
	lig += specular;

	//ライティング結果をテクスチャカラーに乗算。
	albedoColor.xyz *= lig;


	//計算した結果の最終的なカラーを返す。
	return albedoColor;
}
