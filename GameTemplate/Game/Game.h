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
		//to do ライトの方向を追加。

	};
	LightData		m_lightData;

};

