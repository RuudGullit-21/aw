#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если уатОбщегоНазначенияПовтИсп.ИспользоватьЗащитуСЛК() Тогда
		ОткрытьФорму(
			"Обработка.слкМенеджерЛицензий.Форма", 
			,
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	Иначе
		ОткрытьФорму(
			"Обработка.УправлениеЛицензированием.Форма", 
			,
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, 
			ПараметрыВыполненияКоманды.НавигационнаяСсылка
		);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
