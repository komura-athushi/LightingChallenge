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
		//�p�f�B���O
		int pad;
		//���C�g�̕���
		Vector3 lightDirection;
		//�p�f�B���O
		int pad1;
		//�J�������W
		Vector3	eyePos;
	};
	LightData		m_lightData;

};

