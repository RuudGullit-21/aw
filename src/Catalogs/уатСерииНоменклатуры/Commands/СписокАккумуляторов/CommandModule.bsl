#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("ТипАгрегата", "Аккумулятор");
	ОткрытьФорму("Справочник.уатСерииНоменклатуры.Форма.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "Аккумуляторы", ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти
