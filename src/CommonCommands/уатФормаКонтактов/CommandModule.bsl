
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДокументИсточник", ПараметрКоманды);
	
	ОткрытьФорму("ОбщаяФорма.уатФормаКонтактов",ПараметрыФормы,ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти