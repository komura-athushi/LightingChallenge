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
		//���C�g�̐F
		Vector3 lightColor;
		//to do ���C�g�̕�����ǉ��B

	};
	LightData		m_lightData;

};

