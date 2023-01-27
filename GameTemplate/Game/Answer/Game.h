#pragma once
class Game : public IGameObject
{
public:
	Game() {}
	~Game() {}
	bool Start();
	void Update();
	void Render(RenderContext& rc);
private:
	Model			m_model;

	struct LightData {
		//ライトの色
		Vector3 lightColor;
		//パディング
		int pad;
		//ライトの方向
		Vector3 lightDirection;
		//パディング
		int pad1;
		//カメラ座標
		Vector3	eyePos;
	};
	LightData		m_lightData;

};

