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
		//to do1 ライトの方向を追加
		//パディングが必要です

		//to do2 カメラ座標を追加
		//パディングが必要です

	};
	LightData		m_lightData;

};

